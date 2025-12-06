import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';
import 'package:sellerproof/providers/settings_provider.dart';

class TtsSettingsScreen extends StatefulWidget {
  const TtsSettingsScreen({super.key});

  @override
  State<TtsSettingsScreen> createState() => _TtsSettingsScreenState();
}

class _TtsSettingsScreenState extends State<TtsSettingsScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  List<Map<String, dynamic>> _filteredVoices = [];
  bool _isLoadingVoices = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAvailableVoices());
  }

  Future<void> _loadAvailableVoices() async {
    try {
      await _flutterTts.setLanguage('ru-RU');
      final voices = await _flutterTts.getVoices;
      debugPrint('🎤 Voices response: $voices');

      if (voices is List && (voices).isNotEmpty) {
        setState(() {
          _filteredVoices = (voices)
              .whereType<Map>()
              .map((v) {
                final map = v;
                return Map<String, dynamic>.from(map);
              })
              .where((voice) {
                final locale = voice['locale']?.toString().toLowerCase() ?? '';
                final language =
                    voice['language']?.toString().toLowerCase() ?? '';
                final name = voice['name']?.toString().toLowerCase() ?? '';
                return locale.contains('ru') ||
                    language.contains('ru') ||
                    name.contains('russian') ||
                    name.contains('русск') ||
                    name.contains('ru-ru');
              })
              .toList();
          _isLoadingVoices = false;
        });
        debugPrint('🎤 Total RU voices loaded: ${_filteredVoices.length}');
      } else {
        setState(() {
          _filteredVoices = [
            {'name': 'ru-RU', 'locale': 'ru-RU'},
          ];
          _isLoadingVoices = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading or filtering voices: $e');
      setState(() {
        _filteredVoices = [
          {'name': 'ru-RU', 'locale': 'ru-RU'},
        ];
        _isLoadingVoices = false;
      });
    }
  }

  void _onVoiceSelect(String? voiceId) async {
    if (voiceId != null) {
      final selectedVoice = _filteredVoices.firstWhere(
        (v) => v['name'] == voiceId,
        orElse: () => {},
      );
      if (selectedVoice.isNotEmpty) {
        await _flutterTts.setVoice(
          selectedVoice.map((k, v) => MapEntry(k.toString(), v.toString())),
        );
        context.read<SettingsProvider>().setSelectedVoice(voiceId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.voiceSettingsTitle), elevation: 2),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final settings = settingsProvider.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(l.voiceCommandsSection),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.stopCommandLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: settings.stopCommand ?? 'стоп',
                        decoration: InputDecoration(
                          hintText: l.enterWordHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          settingsProvider.setStopCommand(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(l.ttsSettingsSection),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.voiceChoiceLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (_isLoadingVoices)
                        const Center(child: CircularProgressIndicator())
                      else if (_filteredVoices.isEmpty)
                        Text(l.voicesNotFound)
                      else
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minWidth: 300),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue: settings.selectedVoice,
                            hint: Text(l.selectVoiceHint),
                            items:
                                _filteredVoices.map((voice) {
                                  final name = voice['name'].toString();
                                  final locale = voice['locale'].toString();
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(
                                      '$name ($locale)',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                            onChanged: (voiceId) {
                              _onVoiceSelect(voiceId);
                            },
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        l.volumeLabel((settings.ttsVolume * 100).toInt()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: settings.ttsVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${(settings.ttsVolume * 100).toInt()}%',
                        onChanged: (value) {
                          settingsProvider.setTtsVolume(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.speechRateLabel(settings.ttsSpeechRate),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: settings.ttsSpeechRate,
                        min: 0.1,
                        max: 2.0,
                        divisions: 19,
                        label: settings.ttsSpeechRate.toStringAsFixed(2),
                        onChanged: (value) {
                          settingsProvider.setTtsSpeechRate(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _flutterTts.setVolume(settings.ttsVolume);
                            await _flutterTts.setSpeechRate(
                              settings.ttsSpeechRate,
                            );
                            if (settings.selectedVoice != null) {
                              final selectedVoice = _filteredVoices.firstWhere(
                                (v) => v['name'] == settings.selectedVoice,
                                orElse: () => {},
                              );
                              if (selectedVoice.isNotEmpty) {
                                await _flutterTts.setVoice(
                                  selectedVoice.map(
                                    (k, v) =>
                                        MapEntry(k.toString(), v.toString()),
                                  ),
                                );
                              }
                            }
                            await _flutterTts.speak(l.testVoiceText);
                          },
                          icon: const Icon(Icons.volume_up),
                          label: Text(l.testVoiceButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}