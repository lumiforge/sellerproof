enum CommunicationMethod {
  voice,
  bluetoothButton,
}

class AppSettings {
  // 1. Способ коммуникации
  CommunicationMethod communicationMethod;
  
  // 2. Настройки голосовых команд (только для voice)
  String? stopCommand; // Слово для остановки записи
  
  // 3. Настройки TTS (только для voice)
  String? selectedVoice; // Выбранный голос из системных
  double ttsVolume; // Громкость TTS (0.0 - 1.0)
  double ttsSpeechRate; // Скорость речи TTS (0.0 - 1.0+)
  
  // 4. Папка для сохранения видео
  String? videoStoragePath;

  AppSettings({
    this.communicationMethod = CommunicationMethod.voice,
    this.stopCommand = 'стоп',
    this.selectedVoice,
    this.ttsVolume = 1.0,
    this.ttsSpeechRate = 0.5,
    this.videoStoragePath,
  });

  // Копирование с изменениями
  AppSettings copyWith({
    CommunicationMethod? communicationMethod,
    String? stopCommand,
    String? selectedVoice,
    double? ttsVolume,
    double? ttsSpeechRate,
    String? videoStoragePath,
  }) {
    return AppSettings(
      communicationMethod: communicationMethod ?? this.communicationMethod,
      stopCommand: stopCommand ?? this.stopCommand,
      selectedVoice: selectedVoice ?? this.selectedVoice,
      ttsVolume: ttsVolume ?? this.ttsVolume,
      ttsSpeechRate: ttsSpeechRate ?? this.ttsSpeechRate,
      videoStoragePath: videoStoragePath ?? this.videoStoragePath,
    );
  }

  // Сериализация для сохранения в SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'communicationMethod': communicationMethod.index,
      'stopCommand': stopCommand,
      'selectedVoice': selectedVoice,
      'ttsVolume': ttsVolume,
      'ttsSpeechRate': ttsSpeechRate,
      'videoStoragePath': videoStoragePath,
    };
  }

  // Десериализация
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      communicationMethod: CommunicationMethod.values[json['communicationMethod'] ?? 0],
      stopCommand: json['stopCommand'],
      selectedVoice: json['selectedVoice'],
      ttsVolume: json['ttsVolume'] ?? 1.0,
      ttsSpeechRate: json['ttsSpeechRate'] ?? 0.5,
      videoStoragePath: json['videoStoragePath'],
    );
  }
}
