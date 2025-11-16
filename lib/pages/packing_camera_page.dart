import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/vosk_recognition_service.dart';
import '../scan_controller.dart';

class PackingCameraPage extends StatefulWidget {
  final String? initialCode;

  const PackingCameraPage({Key? key, this.initialCode}) : super(key: key);

  @override
  State<PackingCameraPage> createState() => _PackingCameraPageState();
}

class _PackingCameraPageState extends State<PackingCameraPage> {
  static const platform = MethodChannel('com.lumiforge.sellerproof/camera');

  late VoskRecognitionService _voskService;
  bool _isRecording = false;
  bool _isInitializing = true;
  bool _isStopping = false; // Флаг для предотвращения повторных вызовов
  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    _scannedCode = widget.initialCode;
    _initializeVosk();
  }

  Future<void> _initializeVosk() async {
    _voskService = VoskRecognitionService(
      onStopCommand: () {
        debugPrint('🛑 Stop command received from Vosk');
        if (_isRecording && !_isStopping) {
          _stopRecording();
        }
      },
    );

    try {
      await _voskService.initialize();

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }

      // Запускаем нативную камеру (запись начнется автоматически в нативном коде)
      await _startRecording();

      // Запускаем голосовое управление
      await _voskService.startListening();
    } catch (e) {
      debugPrint('Failed to initialize Vosk: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка инициализации голосового управления: $e'),
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    if (!mounted) return;

    try {
      // Запускаем нативную камеру с отсканированным кодом
      await platform.invokeMethod('startCamera', {'scannedCode': _scannedCode});

      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to start camera: '${e.message}'.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка запуска камеры: ${e.message}')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    // Предотвращаем повторные вызовы
    if (_isStopping) {
      debugPrint('⚠️ Already stopping, ignoring duplicate call');
      return;
    }

    _isStopping = true;
    debugPrint('🛑 Starting stop recording process');

    try {
      // Останавливаем голосовое управление первым делом
      await _voskService.stopListening();
      debugPrint('🎤 Voice recognition stopped');

      // Останавливаем запись
      try {
        await platform.invokeMethod('stopCamera');
        debugPrint('📹 Camera stopped');
      } on PlatformException catch (e) {
        debugPrint("⚠️ Failed to stop camera: '${e.message}'.");
      }

      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }

      // Возвращаемся на экран сканирования
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && Navigator.of(context).canPop()) {
            debugPrint('🔙 Popping to scan screen');
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Error in stopRecording: $e");
    }
  }

  @override
  void dispose() {
    debugPrint('🗑️ Disposing PackingCameraPage');
    _voskService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Инициализация камеры...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Если пытаемся выйти во время записи, останавливаем запись
        if (_isRecording && !_isStopping) {
          await _stopRecording();
          return false; // Не выходим сразу, дождемся завершения остановки
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Показываем нативную камеру через platform view
            Container(color: Colors.black),
            // Наложение с информацией
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 50, // Учитываем статус бар
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_scannedCode != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Код:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _scannedCode!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Индикатор записи и подсказка
            if (_isRecording && !_isStopping)
              Positioned(
                bottom: 50,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ИДЕТ ЗАПИСЬ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Скажите "Стоп" для остановки записи',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            // Индикатор остановки
            if (_isStopping)
              Positioned(
                bottom: 50,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Остановка записи...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
