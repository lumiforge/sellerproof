import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

      if (voices is List && (voices as List).isNotEmpty) {
        setState(() {
          _filteredVoices = (voices as List)
              .where((v) => v is Map)
              .map((v) {
                final map = v as Map;
                return Map<String, dynamic>.from(map);
              })
              .where((voice) {
                final locale = voice['locale']?.toString().toLowerCase() ?? '';
                final language = voice['language']?.toString().toLowerCase() ?? '';
                final name = voice['name']?.toString().toLowerCase() ?? '';
                return locale.contains('ru')
                  || language.contains('ru')
                  || name.contains('russian')
                  || name.contains('русск')
                  || name.contains('ru-ru');
              })
              .toList();
          _isLoadingVoices = false;
        });
        debugPrint('🎤 Total RU voices loaded: ${_filteredVoices.length}');
      } else {
        setState(() {
          _filteredVoices = [{'name': 'ru-RU', 'locale': 'ru-RU'}];
          _isLoadingVoices = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading or filtering voices: $e');
      setState(() {
        _filteredVoices = [{'name': 'ru-RU', 'locale': 'ru-RU'}];
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
        await _flutterTts.setVoice(selectedVoice.map((k, v) => MapEntry(k.toString(), v.toString())));
        context.read<SettingsProvider>().setSelectedVoice(voiceId);
      }
    }
  }

  Future<void> _pickVideoStorageFolder(BuildContext context) async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        if (context.mounted) {
          await context.read<SettingsProvider>().setVideoStoragePath(selectedDirectory);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Папка выбрана: $selectedDirectory')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка выбора папки: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        elevation: 2,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final settings = settingsProvider.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader('Способ коммуникации'),
              Card(
                child: Column(
                  children: [
                    RadioListTile<CommunicationMethod>(
                      title: const Text('Голосовое управление'),
                      subtitle: const Text('Использовать голосовые команды'),
                      value: CommunicationMethod.voice,
                      groupValue: settings.communicationMethod,
                      onChanged: (value) {
                        if (value != null) {
                          settingsProvider.setCommunicationMethod(value);
                        }
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<CommunicationMethod>(
                      title: const Text('Bluetooth кнопка'),
                      subtitle: const Text('Использовать Bluetooth кнопку для управления'),
                      value: CommunicationMethod.bluetoothButton,
                      groupValue: settings.communicationMethod,
                      onChanged: (value) {
                        if (value != null) {
                          settingsProvider.setCommunicationMethod(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (settings.communicationMethod == CommunicationMethod.voice) ...[
                _buildSectionHeader('Голосовые команды'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Команда для остановки записи',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: settings.stopCommand ?? 'стоп',
                          decoration: const InputDecoration(
                            hintText: 'Введите слово',
                            border: OutlineInputBorder(),
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
                _buildSectionHeader('Настройки голосового синтеза (TTS)'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Выбор голоса',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (_isLoadingVoices)
                          const Center(child: CircularProgressIndicator())
                        else if (_filteredVoices.isEmpty)
                          const Text('Голоса не найдены')
                        else
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(minWidth: 300),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: settings.selectedVoice,
                              hint: const Text('Выберите голос'),
                              items: _filteredVoices.map((voice) {
                                final name = voice['name'].toString();
                                final locale = voice['locale'].toString();
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text('$name ($locale)', overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (voiceId) {
                                _onVoiceSelect(voiceId);
                              },
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Громкость: ${(settings.ttsVolume * 100).toInt()}%',
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
                          'Скорость речи: ${settings.ttsSpeechRate.toStringAsFixed(2)}',
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
                              await _flutterTts.setSpeechRate(settings.ttsSpeechRate);
                              if (settings.selectedVoice != null) {
                                final selectedVoice = _filteredVoices.firstWhere(
                                  (v) => v['name'] == settings.selectedVoice,
                                  orElse: () => {},
                                );
                                if (selectedVoice.isNotEmpty) {
                                  await _flutterTts.setVoice(selectedVoice.map((k, v) => MapEntry(k.toString(), v.toString())));
                                }
                              }
                              await _flutterTts.speak('Привет, это тест голоса');
                            },
                            icon: const Icon(Icons.volume_up),
                            label: const Text('Проверить голос'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              _buildSectionHeader('Хранение видеозаписей'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Папка для сохранения',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (settings.videoStoragePath != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.folder, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  settings.videoStoragePath!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const Text('Папка не выбрана'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _pickVideoStorageFolder(context),
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Выбрать папку'),
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
