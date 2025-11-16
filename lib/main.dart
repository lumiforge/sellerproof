import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/vosk_recognition_service.dart';
import 'package:provider/provider.dart';
import 'scan_controller.dart';
import 'scan_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ScanController())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sellerproof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScanScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.lumiforge.sellerproof/camera');

  VoskRecognitionService? _voskService;
  bool _isInitializing = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeVosk();
  }

  Future<void> _initializeVosk() async {
    setState(() {
      _isInitializing = true;
    });

    _voskService = VoskRecognitionService(
      onStopCommand: () {
        debugPrint('🛑 Stop command received from Vosk');
        if (_isRecording) {
          _stopRecording();
        }
      },
    );

    try {
      await _voskService!.initialize();
      setState(() {
        _isInitializing = false;
      });
      debugPrint('✅ Vosk ready');
    } catch (e) {
      debugPrint('Failed to initialize Vosk: $e');
      setState(() {
        _isInitializing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка голосового управления: $e')),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      // Сначала запускаем голосовое управление
      await _voskService?.startListening();

      setState(() {
        _isRecording = true;
      });

      // Затем запускаем нативную камеру
      await platform.invokeMethod('startCamera');
    } on PlatformException catch (e) {
      debugPrint("Failed to start camera: '${e.message}'.");
      setState(() {
        _isRecording = false;
      });
      await _voskService?.stopListening();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка запуска камеры: ${e.message}')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Останавливаем голосовое управление
      await _voskService?.stopListening();

      // Останавливаем запись
      await platform.invokeMethod('stopCamera');

      setState(() {
        _isRecording = false;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to stop camera: '${e.message}'.");
      setState(() {
        _isRecording = false;
      });
    }
  }

  @override
  void dispose() {
    _voskService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SellerProof')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isInitializing)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Инициализация голосового управления...'),
                ],
              )
            else ...[
              Icon(
                _isRecording ? Icons.videocam : Icons.videocam_off,
                size: 100,
                color: _isRecording ? Colors.red : Colors.grey,
              ),
              const SizedBox(height: 32),
              if (_isRecording) ...[
                const Text(
                  '🎤 Запись идет',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Скажите "Стоп" для остановки',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isInitializing
                    ? null
                    : (_isRecording ? _stopRecording : _startRecording),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  _isRecording ? 'Остановить запись' : 'Начать запись упаковки',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
