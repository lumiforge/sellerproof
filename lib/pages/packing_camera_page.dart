import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/vosk_recognition_service.dart';

class PackingCameraPage extends StatefulWidget {
  const PackingCameraPage({Key? key}) : super(key: key);

  @override
  State<PackingCameraPage> createState() => _PackingCameraPageState();
}

class _PackingCameraPageState extends State<PackingCameraPage> {
  static const platform = MethodChannel('com.lumiforge.sellerproof/camera');

  late VoskRecognitionService _voskService;
  bool _isRecording = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeVosk();
  }

  Future<void> _initializeVosk() async {
    _voskService = VoskRecognitionService(
      onStopCommand: () {
        debugPrint('🛑 Stop command received from Vosk');
        if (_isRecording) {
          _stopRecording();
        }
      },
    );

    try {
      await _voskService.initialize();
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Failed to initialize Vosk: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка инициализации голосового управления: $e'),
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      // Запускаем нативную камеру
      await platform.invokeMethod('startCamera');

      setState(() {
        _isRecording = true;
      });

      // Запускаем голосовое управление
      await _voskService.startListening();
    } on PlatformException catch (e) {
      debugPrint("Failed to start camera: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка запуска камеры: ${e.message}')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Останавливаем голосовое управление
      await _voskService.stopListening();

      // Останавливаем запись
      await platform.invokeMethod('stopCamera');

      setState(() {
        _isRecording = false;
      });

      // Возвращаемся назад
      if (mounted) {
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to stop camera: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _voskService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись упаковки'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.videocam : Icons.videocam_off,
              size: 100,
              color: _isRecording ? Colors.red : Colors.white,
            ),
            const SizedBox(height: 32),
            if (_isRecording) ...[
              const Text(
                '🎤 Запись идет',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Скажите "Стоп" для остановки',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: Text(
                _isRecording ? 'Остановить' : 'Начать запись',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
