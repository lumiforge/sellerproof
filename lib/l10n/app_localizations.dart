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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
