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
    if (_initCompleter == null) {
      _initCompleter = Completer<void>();
      _initialize();
    }
    return _initCompleter!.future;
  }

  Future<void> _initialize() async {
    try {
      state.value = VoskState.loading;
      _vosk = VoskFlutterPlugin.instance();

      // Путь к модели в assets (архив zip)
      final modelPath = await _loadModelFromAssets(
        'assets/models/vosk-model-small-ru-0.22.zip',
      );

      _model = await _vosk!.createModel(modelPath);
      _recognizer = await _vosk!.createRecognizer(
        model: _model!,
        sampleRate: 16000,
      );

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

      state.value = VoskState.ready;
      _initCompleter!.complete();
      debugPrint('✅ Vosk initialized successfully');
    } catch (e) {
      if (e is PlatformException &&
          e.message!.contains('SpeechService instance already exist')) {
        debugPrint('VoskService: Instance already exists (hot restart)');
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
    if (state.value != VoskState.ready || _speechService == null) {
      debugPrint('Cannot start listening. State: ${state.value}');
      return;
    }

    try {
      await _speechService!.start();
      state.value = VoskState.listening;
      debugPrint('✅ Vosk: Started continuous listening');
    } catch (e) {
      state.value = VoskState.error;
      debugPrint('❌ Error starting Vosk listening: $e');
    }
  }

  Future<void> stopListening() async {
    if (state.value != VoskState.listening || _speechService == null) {
      return;
    }

    try {
      await _speechService!.stop();
      state.value = VoskState.ready;
      debugPrint('✅ Vosk: Stopped listening');
    } catch (e) {
      state.value = VoskState.error;
      debugPrint('❌ Error stopping Vosk: $e');
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
          debugPrint('🛑 Stop command detected: $command');
          onStopCommand();
          break;
        }
      }
    } catch (e) {
      // Ignore parsing errors
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
    await stopListening();
    await _resultSubscription?.cancel();
    await _partialSubscription?.cancel();
    _speechService = null;
    _recognizer?.dispose();
    _model?.dispose();
    state.dispose();
  }
}
