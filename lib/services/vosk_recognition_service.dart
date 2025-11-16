import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class VoskRecognitionService {
  VoskFlutterPlugin? _vosk;
  Model? _model;
  Recognizer? _recognizer;

  bool _isInitialized = false;
  bool _isListening = false;

  Timer? _audioTimer;

  final List<String> stopCommands = [
    'стоп',
    'stop',
    'остановить',
    'остановись',
    'хватит',
    'закончить',
    'стопай',
    'остановка',
  ];

  final Function() onStopCommand;

  VoskRecognitionService({required this.onStopCommand});

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _vosk = VoskFlutterPlugin.instance();

      // Копируем модель из assets в документы
      final modelPath = await _extractModelFromAssets();

      // Создаем модель
      _model = await _vosk!.createModel(modelPath);

      // Создаем распознаватель (16000 Hz - стандарт для vosk)
      _recognizer = await _vosk!.createRecognizer(
        model: _model!,
        sampleRate: 16000,
      );

      // Устанавливаем слушатель результатов
      if (_recognizer != null) {
        _recognizer!.setResultListener((result) {
          debugPrint('🎤 Vosk result: $result');
          _checkForStopCommand(result);
        });

        _recognizer!.setPartialResultListener((partial) {
          debugPrint('🎤 Vosk partial: $partial');
          _checkForStopCommand(partial);
        });
      }

      _isInitialized = true;
      debugPrint('✅ Vosk initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Vosk: $e');
      rethrow;
    }
  }

  Future<String> _extractModelFromAssets() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelPath = '${directory.path}/vosk-model-small-ru';

    // Проверяем, скопирована ли модель
    final modelDir = Directory(modelPath);
    if (await modelDir.exists()) {
      debugPrint('Model already exists at $modelPath');
      return modelPath;
    }

    // Копируем модель из assets
    debugPrint('Extracting model to $modelPath...');
    await modelDir.create(recursive: true);

    // Получаем список файлов из assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Копируем все файлы модели
    final modelFiles = manifestMap.keys
        .where(
          (String key) => key.startsWith('assets/models/vosk-model-small-ru/'),
        )
        .toList();

    for (final assetPath in modelFiles) {
      final relativePath = assetPath.replaceFirst(
        'assets/models/vosk-model-small-ru/',
        '',
      );
      if (relativePath.isEmpty) continue;

      final targetPath = '$modelPath/$relativePath';
      final targetFile = File(targetPath);

      // Создаем директории если нужно
      await targetFile.parent.create(recursive: true);

      // Копируем файл
      final data = await rootBundle.load(assetPath);
      await targetFile.writeAsBytes(data.buffer.asUint8List());

      debugPrint('Copied: $relativePath');
    }

    debugPrint('✅ Model extracted successfully');
    return modelPath;
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isListening) return;

    try {
      // Используем микрофон через recognizer
      _recognizer?.start();
      _isListening = true;

      // Периодически обновляем аудио (в версии 0.3.48 нужно вручную читать)
      _startAudioProcessing();

      debugPrint('✅ Vosk: Started continuous listening');
    } catch (e) {
      debugPrint('❌ Error starting Vosk listening: $e');
      rethrow;
    }
  }

  void _startAudioProcessing() {
    // В версии 0.3.48 используем таймер для постоянного прослушивания
    _audioTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) async {
      if (!_isListening) {
        timer.cancel();
        return;
      }

      try {
        // Обрабатываем аудио
        await _recognizer?.acceptWaveform();
      } catch (e) {
        debugPrint('Error processing audio: $e');
      }
    });
  }

  void _checkForStopCommand(String text) {
    // Парсим JSON результат
    try {
      final result = json.decode(text);
      final recognizedText = (result['text'] ?? result['partial'] ?? '')
          .toString()
          .toLowerCase();

      for (final command in stopCommands) {
        if (recognizedText.contains(command)) {
          debugPrint('🛑 Stop command detected: $command');
          onStopCommand();
          break;
        }
      }
    } catch (e) {
      // Если не JSON, проверяем напрямую
      final lowerText = text.toLowerCase();
      for (final command in stopCommands) {
        if (lowerText.contains(command)) {
          debugPrint('🛑 Stop command detected: $command');
          onStopCommand();
          break;
        }
      }
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      _audioTimer?.cancel();
      _audioTimer = null;

      _recognizer?.stop();

      _isListening = false;

      debugPrint('✅ Vosk: Stopped listening');
    } catch (e) {
      debugPrint('❌ Error stopping Vosk: $e');
    }
  }

  Future<void> dispose() async {
    await stopListening();

    _recognizer?.dispose();
    _model?.dispose();

    _recognizer = null;
    _model = null;
    _isInitialized = false;
  }
}
