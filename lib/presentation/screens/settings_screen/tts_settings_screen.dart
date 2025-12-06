import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';
import 'package:sellerproof/presentation/theme/app_colors.dart';
import 'package:sellerproof/presentation/widgets/app_input.dart';
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
  late TextEditingController _stopCommandController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _stopCommandController = TextEditingController(
      text: settings.stopCommand ?? 'стоп',
    );
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
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: AppColors.slate900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              l.voiceSettingsTitle,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.voiceSettingsSubtitle,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate500),
            ),
            const SizedBox(height: 24),

            // Voice Commands Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.slate200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.mic,
                        color: AppColors.sky600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.voiceCommandsSection,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppInput(
                    label: l.stopCommandLabel,
                    placeholder: l.enterWordHint,
                    icon: LucideIcons.mic,
                    controller: _stopCommandController,
                    onChanged: (value) {
                      if (value != null) settingsProvider.setStopCommand(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // TTS Settings Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.slate200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.volume2,
                        color: AppColors.sky600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.ttsSettingsSection,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Voice Selection
                  Text(
                    l.voiceChoiceLabel,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate900.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_isLoadingVoices)
                    const Center(child: CircularProgressIndicator())
                  else if (_filteredVoices.isEmpty)
                    Text(l.voicesNotFound)
                  else
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.slate200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.sky500,
                            width: 1,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        LucideIcons.chevronDown,
                        color: AppColors.slate500,
                        size: 16,
                      ),
                      value: settings.selectedVoice,
                      hint: Text(l.selectVoiceHint),
                      items: _filteredVoices.map((voice) {
                        final name = voice['name'].toString();
                        final locale = voice['locale'].toString();
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(
                            '$name ($locale)',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: AppColors.slate900,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _onVoiceSelect,
                    ),
                  const SizedBox(height: 24),

                  // Volume
                  Text(
                    l.volumeLabel((settings.ttsVolume * 100).toInt()),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate700,
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.sky600,
                      inactiveTrackColor: AppColors.slate200,
                      thumbColor: AppColors.sky600,
                      overlayColor: AppColors.sky600.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: settings.ttsVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      onChanged: (value) {
                        settingsProvider.setTtsVolume(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Speech Rate
                  Text(
                    l.speechRateLabel(settings.ttsSpeechRate),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate700,
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.sky600,
                      inactiveTrackColor: AppColors.slate200,
                      thumbColor: AppColors.sky600,
                      overlayColor: AppColors.sky600.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: settings.ttsSpeechRate,
                      min: 0.1,
                      max: 3.0,
                      divisions: 29,
                      onChanged: (value) {
                        settingsProvider.setTtsSpeechRate(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l.slow,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate400,
                          ),
                        ),
                        Text(
                          l.fast,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Test Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _flutterTts.setVolume(settings.ttsVolume);
                        await _flutterTts.setSpeechRate(settings.ttsSpeechRate);
                        if (settings.selectedVoice != null) {
                          final selectedVoice = _filteredVoices.firstWhere(
                            (v) => v['name'] == settings.selectedVoice,
                            orElse: () => {},
                          );
                          if (selectedVoice.isNotEmpty) {
                            await _flutterTts.setVoice(
                              selectedVoice.map(
                                (k, v) => MapEntry(k.toString(), v.toString()),
                              ),
                            );
                          }
                        }
                        await _flutterTts.speak(l.testVoiceText);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        foregroundColor: Colors.white,
                        shadowColor: AppColors.emerald200,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(LucideIcons.play, size: 16),
                      label: Text(l.testVoiceButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopCommandController.dispose();
    _flutterTts.stop();
    super.dispose();
  }
}
