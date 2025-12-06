// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SellerProof';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageSection => 'Язык';

  @override
  String get languagePickerLabel => 'Язык приложения';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get communicationMethod => 'Способ коммуникации';

  @override
  String get voiceControlTitle => 'Голосовое управление';

  @override
  String get voiceControlSubtitle => 'Использовать голосовые команды';

  @override
  String get bluetoothButtonTitle => 'Bluetooth кнопка';

  @override
  String get bluetoothButtonSubtitle => 'Использовать Bluetooth кнопку для управления';

  @override
  String get voiceCommandsSection => 'Голосовые команды';

  @override
  String get stopCommandLabel => 'Команда для остановки записи';

  @override
  String get enterWordHint => 'Введите слово';

  @override
  String get ttsSettingsSection => 'Настройки голосового синтеза (TTS)';

  @override
  String get voiceChoiceLabel => 'Выбор голоса';

  @override
  String get voicesNotFound => 'Голоса не найдены';

  @override
  String get selectVoiceHint => 'Выберите голос';

  @override
  String volumeLabel(int percent) {
    return 'Громкость: $percent%';
  }

  @override
  String speechRateLabel(double rate) {
    return 'Скорость речи: $rate';
  }

  @override
  String get testVoiceButton => 'Проверить голос';

  @override
  String get testVoiceText => 'Привет, это тест голоса';

  @override
  String get videoStorageSection => 'Хранение видеозаписей';

  @override
  String get folderLabel => 'Папка для сохранения';

  @override
  String get folderNotSelected => 'Папка не выбрана';

  @override
  String get chooseFolderButton => 'Выбрать папку';

  @override
  String folderSelectedSnackbar(String path) {
    return 'Папка выбрана: $path';
  }

  @override
  String folderSelectError(String error) {
    return 'Ошибка выбора папки: $error';
  }
}
