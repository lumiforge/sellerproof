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
  String get bluetoothButtonSubtitle =>
      'Использовать Bluetooth кнопку для управления';

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

  @override
  String get loginTitle => 'С возвращением';

  @override
  String get loginSubtitle => 'Войдите, чтобы получить доступ к панели';

  @override
  String get emailLabel => 'Адрес электронной почты';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get emailValidator => 'Введите email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get passwordValidator => 'Введите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signInButton => 'Войти';

  @override
  String get noAccountText => 'Нет аккаунта?';

  @override
  String get signUpLink => 'Зарегистрироваться';

  @override
  String get registerTitle => 'Создание аккаунта';

  @override
  String get registerSubtitle =>
      'Присоединяйтесь к SellerProof для безопасных транзакций';

  @override
  String get fullNameLabel => 'Полное имя';

  @override
  String get fullNamePlaceholder => 'Иван Иванов';

  @override
  String get fullNameValidator => 'Введите имя';

  @override
  String get joinOrganization => 'Присоединиться к организации';

  @override
  String get createOrganization => 'Создать организацию';

  @override
  String get inviteCodeLabel => 'Код приглашения';

  @override
  String get inviteCodePlaceholder => 'Введите код';

  @override
  String get inviteCodeValidator => 'Введите код приглашения';

  @override
  String get orgNameLabel => 'Название организации';

  @override
  String get orgNamePlaceholder => 'Acme Corp';

  @override
  String get orgNameValidator => 'Введите название организации';

  @override
  String get createAccountButton => 'Создать аккаунт';

  @override
  String get alreadyHaveAccountText => 'Уже есть аккаунт?';

  @override
  String get loginLink => 'Войти';

  @override
  String get verifyEmailTitle => 'Подтверждение почты';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Код отправлен на $email';
  }

  @override
  String get verificationCodeLabel => 'Код подтверждения';

  @override
  String get verificationCodePlaceholder => '123456';

  @override
  String get verifyButton => 'Подтвердить';

  @override
  String get emailVerifiedSnackbar => 'Почта подтверждена. Войдите в аккаунт.';

  @override
  String get scannerInitializing => 'Инициализация сканера...';

  @override
  String get preparingCamera => 'Подготовка камеры...';

  @override
  String get codeFoundTitle => 'Код найден:';

  @override
  String get startingRecording => 'Запуск видеозаписи...';

  @override
  String get aimCameraHelper => 'Наведите камеру на QR или штрих‑код';
}
