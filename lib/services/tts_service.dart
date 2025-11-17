import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Сервис для озвучивания событий — теперь с комбинированной фразой записи и кода.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ TtsService: Already initialized');
      return;
    }

    try {
      _flutterTts = FlutterTts();
      await _flutterTts!.setLanguage("ru-RU");
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.0);
      _flutterTts!.setStartHandler(() { _isSpeaking = true; });
      _flutterTts!.setCompletionHandler(() { _isSpeaking = false; });
      _flutterTts!.setErrorHandler((msg) { _isSpeaking = false; });
      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ TtsService: Initialization error: $e');
      _isInitialized = false;
    }
  }
  
  Future<void> speakRecordWithCode(String code) async {
    if (!_isInitialized) await initialize();
    if (_flutterTts == null) return;
    try {
      if (_isSpeaking) await _flutterTts!.stop();
      final lastFour = code.length >= 4 ? code.substring(code.length - 4) : code;
      final digits = lastFour.split('').join(' ');
      final phrase = 'Запись $digits началась';
      debugPrint('🔊 TtsService: $phrase');
      await _flutterTts!.speak(phrase);
    } catch (e) {
      debugPrint('❌ TtsService: Error speaking record with code: $e');
    }
  }

  Future<void> announceRecordingStopped() async {
    if (!_isInitialized) await initialize();
    if (_flutterTts == null) return;
    try {
      if (_isSpeaking) await _flutterTts!.stop();
      await _flutterTts!.speak('Остановлена');
    } catch (e) {
      debugPrint('❌ TtsService: Error announcing stop: $e');
    }
  }

  Future<void> stop() async {
    if (_flutterTts != null && _isSpeaking) await _flutterTts!.stop(); _isSpeaking = false;
  }

  Future<void> dispose() async {
    if (_flutterTts != null) { await _flutterTts!.stop(); _flutterTts = null; _isInitialized = false; }
  }
}
