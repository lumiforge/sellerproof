// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SellerProof';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSection => 'Language';

  @override
  String get languagePickerLabel => 'App language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get communicationMethod => 'Communication method';

  @override
  String get voiceControlTitle => 'Voice control';

  @override
  String get voiceControlSubtitle => 'Use voice commands';

  @override
  String get bluetoothButtonTitle => 'Bluetooth button';

  @override
  String get bluetoothButtonSubtitle => 'Use a Bluetooth button to control';

  @override
  String get voiceCommandsSection => 'Voice commands';

  @override
  String get stopCommandLabel => 'Stop recording word';

  @override
  String get enterWordHint => 'Enter a word';

  @override
  String get ttsSettingsSection => 'Text‑to‑speech (TTS) settings';

  @override
  String get voiceChoiceLabel => 'Voice selection';

  @override
  String get voicesNotFound => 'No voices found';

  @override
  String get selectVoiceHint => 'Select a voice';

  @override
  String volumeLabel(int percent) {
    return 'Volume: $percent%';
  }

  @override
  String speechRateLabel(double rate) {
    return 'Speech rate: $rate';
  }

  @override
  String get testVoiceButton => 'Test voice';

  @override
  String get testVoiceText => 'Hello, this is a voice test';

  @override
  String get videoStorageSection => 'Video recordings storage';

  @override
  String get folderLabel => 'Save folder';

  @override
  String get folderNotSelected => 'Folder not selected';

  @override
  String get chooseFolderButton => 'Choose folder';

  @override
  String folderSelectedSnackbar(String path) {
    return 'Folder selected: $path';
  }

  @override
  String folderSelectError(String error) {
    return 'Folder selection error: $error';
  }
}
