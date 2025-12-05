import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../services/vosk_recognition_service.dart';
import '../../../services/tts_service.dart';

import '../../../providers/settings_provider.dart';

class PackingCameraPage extends StatefulWidget {
  final String? initialCode;

  const PackingCameraPage({super.key, this.initialCode});

  @override
  State<PackingCameraPage> createState() => _PackingCameraPageState();
}

class _PackingCameraPageState extends State<PackingCameraPage> {
  static const platform = MethodChannel('com.lumiforge.sellerproof/camera');

  late VoskRecognitionService _voskService;
  final TtsService _ttsService = TtsService();
  bool _isRecording = false;
  bool _isInitializing = true;
  bool _isStopping = false;
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
      await _startRecording();
      await Future.delayed(const Duration(milliseconds: 500));
      await _voskService.startListening();
      debugPrint('✅ Voice recognition started for recording');
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
      // Get custom storage path from settings provider
      final settingsProvider = Provider.of<SettingsProvider>(
        context,
        listen: false,
      );
      final storagePath = settingsProvider.settings.videoStoragePath;

      debugPrint(
        '🎬 Starting recording with code: $_scannedCode, storagePath: $storagePath',
      );

      await platform.invokeMethod('startCamera', {
        'scannedCode': _scannedCode,
        'storagePath': storagePath,
      });

      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
      // Новая озвучка — "Запись {код} началась"
      if (_scannedCode != null && _scannedCode!.isNotEmpty) {
        await _ttsService.speakRecordWithCode(_scannedCode!);
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
    if (_isStopping) {
      debugPrint('⚠️ Already stopping, ignoring duplicate call');
      return;
    }
    _isStopping = true;
    debugPrint('🛑 Starting stop recording process');
    try {
      await _ttsService.announceRecordingStopped();
      await _voskService.stopListening();
      debugPrint('🎤 Voice recognition stopped');
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
    if (_voskService.state.value == VoskState.listening) {
      _voskService.stopListening();
    }
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
        if (_isRecording && !_isStopping) {
          await _stopRecording();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 50,
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint('🛑 Stop button pressed');
                          if (_isRecording && !_isStopping) {
                            _stopRecording();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stop, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Остановить запись',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
