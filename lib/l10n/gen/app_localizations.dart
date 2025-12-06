import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SellerProof'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languagePickerLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languagePickerLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @communicationMethod.
  ///
  /// In en, this message translates to:
  /// **'Communication method'**
  String get communicationMethod;

  /// No description provided for @voiceControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice control'**
  String get voiceControlTitle;

  /// No description provided for @voiceControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use voice commands'**
  String get voiceControlSubtitle;

  /// No description provided for @bluetoothButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth button'**
  String get bluetoothButtonTitle;

  /// No description provided for @bluetoothButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a Bluetooth button to control'**
  String get bluetoothButtonSubtitle;

  /// No description provided for @voiceCommandsSection.
  ///
  /// In en, this message translates to:
  /// **'Voice commands'**
  String get voiceCommandsSection;

  /// No description provided for @stopCommandLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop recording word'**
  String get stopCommandLabel;

  /// No description provided for @enterWordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a word'**
  String get enterWordHint;

  /// No description provided for @ttsSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Text‑to‑speech (TTS) settings'**
  String get ttsSettingsSection;

  /// No description provided for @voiceChoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Voice selection'**
  String get voiceChoiceLabel;

  /// No description provided for @voicesNotFound.
  ///
  /// In en, this message translates to:
  /// **'No voices found'**
  String get voicesNotFound;

  /// No description provided for @selectVoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Select a voice'**
  String get selectVoiceHint;

  /// No description provided for @volumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume: {percent}%'**
  String volumeLabel(int percent);

  /// No description provided for @speechRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Speech rate: {rate}'**
  String speechRateLabel(double rate);

  /// No description provided for @testVoiceButton.
  ///
  /// In en, this message translates to:
  /// **'Test voice'**
  String get testVoiceButton;

  /// No description provided for @testVoiceText.
  ///
  /// In en, this message translates to:
  /// **'Hello, this is a voice test'**
  String get testVoiceText;

  /// No description provided for @videoStorageSection.
  ///
  /// In en, this message translates to:
  /// **'Video recordings storage'**
  String get videoStorageSection;

  /// No description provided for @folderLabel.
  ///
  /// In en, this message translates to:
  /// **'Save folder'**
  String get folderLabel;

  /// No description provided for @folderNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Folder not selected'**
  String get folderNotSelected;

  /// No description provided for @chooseFolderButton.
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get chooseFolderButton;

  /// No description provided for @folderSelectedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Folder selected: {path}'**
  String folderSelectedSnackbar(String path);

  /// No description provided for @folderSelectError.
  ///
  /// In en, this message translates to:
  /// **'Folder selection error: {error}'**
  String folderSelectError(String error);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your dashboard'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailPlaceholder;

  /// No description provided for @emailValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get emailValidator;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordPlaceholder;

  /// No description provided for @passwordValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordValidator;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @noAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountText;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join SellerProof for secure transactions'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNamePlaceholder;

  /// No description provided for @fullNameValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get fullNameValidator;

  /// No description provided for @joinOrganization.
  ///
  /// In en, this message translates to:
  /// **'Join Organization'**
  String get joinOrganization;

  /// No description provided for @createOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create Organization'**
  String get createOrganization;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get inviteCodePlaceholder;

  /// No description provided for @inviteCodeValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter invite code'**
  String get inviteCodeValidator;

  /// No description provided for @orgNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get orgNameLabel;

  /// No description provided for @orgNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Acme Corp'**
  String get orgNamePlaceholder;

  /// No description provided for @orgNameValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter organization name'**
  String get orgNameValidator;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountText;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {email}'**
  String verifyEmailSubtitle(String email);

  /// No description provided for @verificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeLabel;

  /// No description provided for @verificationCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get verificationCodePlaceholder;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @emailVerifiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Email verified. Please sign in.'**
  String get emailVerifiedSnackbar;

  /// No description provided for @scannerInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing scanner...'**
  String get scannerInitializing;

  /// No description provided for @preparingCamera.
  ///
  /// In en, this message translates to:
  /// **'Preparing camera...'**
  String get preparingCamera;

  /// No description provided for @codeFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Code found:'**
  String get codeFoundTitle;

  /// No description provided for @startingRecording.
  ///
  /// In en, this message translates to:
  /// **'Starting recording...'**
  String get startingRecording;

  /// No description provided for @aimCameraHelper.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a QR or barcode'**
  String get aimCameraHelper;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @inviteUser.
  ///
  /// In en, this message translates to:
  /// **'Invite User'**
  String get inviteUser;

  /// No description provided for @voiceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice & TTS Settings'**
  String get voiceSettingsTitle;

  /// No description provided for @voiceSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage voice commands and speech synthesis'**
  String get voiceSettingsSubtitle;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
