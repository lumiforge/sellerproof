import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

enum VoskState { uninitialized, loading, ready, listening, error }

class VoskRecognitionService {
  // Singleton instance
  static VoskRecognitionService? _instance;

  VoskFlutterPlugin? _vosk;
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  final ValueNotifier<VoskState> state = ValueNotifier<VoskState>(
    VoskState.uninitialized,
  );

  StreamSubscription<String>? _resultSubscription;
  StreamSubscription<String>? _partialSubscription;
  Completer<void>? _initCompleter;

  // Debouncing для команды "стоп"
  DateTime? _lastStopCommandTime;
  static const _stopCommandDebounce = Duration(milliseconds: 1000);
  bool _stopCommandProcessed = false;

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

  Function()? _onStopCommand;

  // Private constructor
  VoskRecognitionService._internal();

  // Factory constructor для singleton
  factory VoskRecognitionService({required Function() onStopCommand}) {
    if (_instance == null) {
      debugPrint('🆕 Creating new VoskRecognitionService instance');
      _instance = VoskRecognitionService._internal();
    } else {
      debugPrint('♻️ Reusing existing VoskRecognitionService instance');
    }

    // Обновляем callback
    _instance!._onStopCommand = onStopCommand;

    return _instance!;
  }

  // Метод для сброса singleton (использовать осторожно)
  static Future<void> reset() async {
    if (_instance != null) {
      debugPrint('🔄 Resetting VoskRecognitionService singleton');
      await _instance!.dispose();
      _instance = null;
    }
  }

  Future<void> initialize() async {
    if (_initCompleter == null) {
      _initCompleter = Completer<void>();
      _initialize();
    }
    return _initCompleter!.future;
  }

  Future<void> _initialize() async {
    try {
      state.value = VoskState.loading;

      _vosk ??= VoskFlutterPlugin.instance();

      // Путь к модели в assets (архив zip)
      final modelPath = await _loadModelFromAssets(
        'assets/models/vosk-model-small-ru-0.22.zip',
      );

      _model ??= await _vosk!.createModel(modelPath);

      _recognizer ??= await _vosk!.createRecognizer(
        model: _model!,
        sampleRate: 16000,
      );

      if (_speechService == null) {
        _speechService = await _vosk!.initSpeechService(_recognizer!);

        // Слушаем результаты распознавания
        _resultSubscription = _speechService!.onResult().listen((result) {
          debugPrint('🎤 Vosk result: $result');
          _checkForStopCommand(result);
        });

        // Слушаем частичные результаты для быстрого отклика
        _partialSubscription = _speechService!.onPartial().listen((partial) {
          debugPrint('🎤 Vosk partial: $partial');
          _checkForStopCommand(partial);
        });
      }

      state.value = VoskState.ready;
      _initCompleter!.complete();
      debugPrint('✅ Vosk initialized successfully');
    } catch (e) {
      if (e is PlatformException &&
          e.message!.contains('SpeechService instance already exist')) {
        debugPrint('♻️ VoskService: Instance already exists, reusing');
        state.value = VoskState.ready;
        _initCompleter!.complete();
      } else {
        state.value = VoskState.error;
        _initCompleter!.completeError(e, StackTrace.current);
        debugPrint('❌ Error initializing Vosk: $e');
      }
    }
  }

  Future<void> startListening() async {
    debugPrint('🎤 startListening called, current state: ${state.value}');

    if (_speechService == null) {
      debugPrint('❌ Cannot start listening: _speechService is null');
      return;
    }

    if (state.value == VoskState.listening) {
      debugPrint('⚠️ Already listening, skipping');
      return;
    }

    if (state.value != VoskState.ready) {
      debugPrint('⚠️ Cannot start listening. State: ${state.value}');
      return;
    }

    try {
      // Сбрасываем флаг при начале нового прослушивания
      _stopCommandProcessed = false;
      _lastStopCommandTime = null;

      await _speechService!.start();
      state.value = VoskState.listening;
      debugPrint('✅ Vosk: Started continuous listening');
    } catch (e) {
      state.value = VoskState.error;
      debugPrint('❌ Error starting Vosk listening: $e');
    }
  }

  Future<void> stopListening() async {
    debugPrint('🛑 stopListening called, current state: ${state.value}');

    if (_speechService == null) {
      debugPrint('⚠️ _speechService is null, nothing to stop');
      return;
    }

    if (state.value != VoskState.listening) {
      debugPrint('⚠️ Not listening, skipping stop. State: ${state.value}');
      return;
    }

    try {
      await _speechService!.stop();
      state.value = VoskState.ready;
      debugPrint('✅ Vosk: Stopped listening');
    } catch (e) {
      debugPrint('❌ Error stopping Vosk: $e');
      // Все равно переводим в ready, чтобы можно было снова запустить
      state.value = VoskState.ready;
    }
  }

  void _checkForStopCommand(String result) {
    try {
      final jsonResult = jsonDecode(result);
      final text =
          (jsonResult['text'] ?? jsonResult['partial'] ?? '') as String;

      if (text.isEmpty) return;

      final lowerText = text.toLowerCase();

      for (final command in stopCommands) {
        if (lowerText.contains(command)) {
          // Проверяем debouncing
          final now = DateTime.now();

          // Если команда уже была обработана, игнорируем
          if (_stopCommandProcessed) {
            debugPrint('⚠️ Stop command already processed, ignoring');
            return;
          }

          // Проверяем, не была ли команда недавно
          if (_lastStopCommandTime != null &&
              now.difference(_lastStopCommandTime!) < _stopCommandDebounce) {
            debugPrint(
              '⚠️ Stop command ignored (debounce): too soon after last command',
            );
            return;
          }

          // Обновляем время последней команды и устанавливаем флаг
          _lastStopCommandTime = now;
          _stopCommandProcessed = true;

          debugPrint('🛑 Stop command detected: $command (from text: "$text")');

          // Вызываем callback если он установлен
          _onStopCommand?.call();

          break;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error parsing Vosk result: $e');
    }
  }

  Future<String> _loadModelFromAssets(String assetPath) async {
    final tempDir = await getTemporaryDirectory();
    final modelName = assetPath.split('/').last.replaceAll('.zip', '');
    final modelDir = Directory('${tempDir.path}/$modelName');

    if (!await modelDir.exists()) {
      debugPrint('Extracting model to ${modelDir.path}...');
      await modelDir.create(recursive: true);

      final assetData = await rootBundle.load(assetPath);
      final bytes = assetData.buffer.asUint8List();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = '${modelDir.path}/${file.name}';
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(filename).create(recursive: true);
        }
      }
      debugPrint('✅ Model extracted successfully');
    } else {
      debugPrint('Model already exists at ${modelDir.path}');
    }

    return '${modelDir.path}/$modelName';
  }

  Future<void> dispose() async {
    debugPrint('🗑️ VoskRecognitionService: dispose called');
    await stopListening();
    // НЕ отменяем подписки и не чистим ресурсы для singleton
    // Они будут переиспользованы
    debugPrint(
      '✅ VoskRecognitionService: dispose complete (singleton preserved)',
    );
  }

  // // Полная очистка (только для сброса singleton)
  // Future<void> _fullDispose() async {
  //   debugPrint('🗑️ VoskRecognitionService: full dispose');
  //   await stopListening();
  //   await _resultSubscription?.cancel();
  //   await _partialSubscription?.cancel();
  //   _speechService = null;
  //   _recognizer?.dispose();
  //   _model?.dispose();
  //   _vosk = null;
  //   _initCompleter = null;
  // }
}
