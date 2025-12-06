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

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to access your dashboard';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get emailValidator => 'Enter email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get passwordValidator => 'Enter password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get signInButton => 'Sign in';

  @override
  String get noAccountText => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle => 'Join SellerProof for secure transactions';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNamePlaceholder => 'John Doe';

  @override
  String get fullNameValidator => 'Enter full name';

  @override
  String get joinOrganization => 'Join Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get inviteCodeLabel => 'Invite Code';

  @override
  String get inviteCodePlaceholder => 'Enter code';

  @override
  String get inviteCodeValidator => 'Enter invite code';

  @override
  String get orgNameLabel => 'Organization Name';

  @override
  String get orgNamePlaceholder => 'Acme Corp';

  @override
  String get orgNameValidator => 'Enter organization name';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get alreadyHaveAccountText => 'Already have an account?';

  @override
  String get loginLink => 'Log in';

  @override
  String get verifyEmailTitle => 'Verify Email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Code sent to $email';
  }

  @override
  String get verificationCodeLabel => 'Verification Code';

  @override
  String get verificationCodePlaceholder => '123456';

  @override
  String get verifyButton => 'Verify';

  @override
  String get emailVerifiedSnackbar => 'Email verified. Please sign in.';

  @override
  String get scannerInitializing => 'Initializing scanner...';

  @override
  String get preparingCamera => 'Preparing camera...';

  @override
  String get codeFoundTitle => 'Code found:';

  @override
  String get startingRecording => 'Starting recording...';

  @override
  String get aimCameraHelper => 'Point the camera at a QR or barcode';

  @override
  String get logout => 'Log out';

  @override
  String get inviteUser => 'Invite User';

  @override
  String get voiceSettingsTitle => 'Voice & TTS Settings';
}
