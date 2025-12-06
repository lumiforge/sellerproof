import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sellerproof/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';

  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  // Инициализация - загрузка настроек из SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> decoded = json.decode(settingsJson);
        _settings = AppSettings.fromJson(decoded);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Сохранение настроек
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(_settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Обновление настроек
  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _saveSettings();
  }

  // Удобные методы для обновления отдельных полей

  Future<void> setCommunicationMethod(CommunicationMethod method) async {
    _settings = _settings.copyWith(communicationMethod: method);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setStopCommand(String command) async {
    _settings = _settings.copyWith(stopCommand: command);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setSelectedVoice(String voice) async {
    _settings = _settings.copyWith(selectedVoice: voice);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setTtsVolume(double volume) async {
    _settings = _settings.copyWith(ttsVolume: volume);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setTtsSpeechRate(double rate) async {
    _settings = _settings.copyWith(ttsSpeechRate: rate);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setVideoStoragePath(String path) async {
    _settings = _settings.copyWith(videoStoragePath: path);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setLanguageCode(String code) async {
    _settings = _settings.copyWith(languageCode: code);
    notifyListeners();
    await _saveSettings();
  }
}
