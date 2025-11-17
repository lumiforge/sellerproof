import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Singleton service for Text-to-Speech functionality.
/// Provides audio feedback for various app events.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;

  /// Initialize TTS engine with Russian language settings.
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ TtsService: Already initialized');
      return;
    }

    try {
      _flutterTts = FlutterTts();

      // Настройка для русского языка
      await _flutterTts!.setLanguage("ru-RU");
      await _flutterTts!.setSpeechRate(0.5); // Нормальная скорость
      await _flutterTts!.setVolume(1.0); // Максимальная громкость
      await _flutterTts!.setPitch(1.0); // Нормальная высота тона

      // Обработчики состояний
      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
        debugPrint('🔊 TTS: Started speaking');
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        debugPrint('✅ TTS: Completed speaking');
      });

      _flutterTts!.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('❌ TTS Error: $msg');
      });

      _isInitialized = true;
      debugPrint('✅ TtsService: Initialized successfully');
    } catch (e) {
      debugPrint('❌ TtsService: Initialization error: $e');
      _isInitialized = false;
    }
  }

  /// Speak the last 4 digits of a scanned code.
  /// If code is shorter than 4 digits, speaks the entire code.
  Future<void> speakLastFourDigits(String code) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_flutterTts == null) {
      debugPrint('⚠️ TtsService: Not initialized, cannot speak');
      return;
    }

    try {
      // Останавливаем текущую речь, если есть
      if (_isSpeaking) {
        await _flutterTts!.stop();
      }

      // Получаем последние 4 символа (или меньше, если код короче)
      final lastFour = code.length >= 4 
          ? code.substring(code.length - 4) 
          : code;
      
      // Разделяем цифры пробелами для четкого произношения
      final digitsToSpeak = lastFour.split('').join(' ');
      
      debugPrint('🔊 TtsService: Speaking last 4 digits: $digitsToSpeak');
      await _flutterTts!.speak(digitsToSpeak);
    } catch (e) {
      debugPrint('❌ TtsService: Error speaking digits: $e');
    }
  }

  /// Announce that recording has started.
  Future<void> announceRecordingStarted() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_flutterTts == null) {
      debugPrint('⚠️ TtsService: Not initialized, cannot speak');
      return;
    }

    try {
      // Останавливаем текущую речь, если есть
      if (_isSpeaking) {
        await _flutterTts!.stop();
      }

      debugPrint('🔊 TtsService: Announcing recording started');
      await _flutterTts!.speak('Запись началась');
    } catch (e) {
      debugPrint('❌ TtsService: Error announcing start: $e');
    }
  }

  /// Announce that recording has stopped.
  Future<void> announceRecordingStopped() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_flutterTts == null) {
      debugPrint('⚠️ TtsService: Not initialized, cannot speak');
      return;
    }

    try {
      // Останавливаем текущую речь, если есть
      if (_isSpeaking) {
        await _flutterTts!.stop();
      }

      debugPrint('🔊 TtsService: Announcing recording stopped');
      await _flutterTts!.speak('Остановлена');
    } catch (e) {
      debugPrint('❌ TtsService: Error announcing stop: $e');
    }
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    if (_flutterTts != null && _isSpeaking) {
      await _flutterTts!.stop();
      _isSpeaking = false;
    }
  }

  /// Dispose of TTS resources.
  /// Should only be called when app is shutting down.
  Future<void> dispose() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
      _flutterTts = null;
      _isInitialized = false;
      debugPrint('🗑️ TtsService: Disposed');
    }
  }
}
