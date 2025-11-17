import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Controller for scanning and recording logic.
class ScanAndRecordController extends ChangeNotifier {
  CameraController? cameraController;
  MobileScannerController? scannerController;
  bool cameraReady = false;
  bool isScanning = false;
  bool isRecording = false;
  String? lastScannedCode;
  String? savedVideoPath;
  String? customStoragePath;

  /// Call this when initializing the screen.
  Future<void> initialize({String? storagePath}) async {
    customStoragePath = storagePath;
    // Initialize scanner controller with autoStart disabled
    scannerController = MobileScannerController(autoStart: false);

    // Initialize camera controller for video recording
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back),
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();

    cameraReady = true;
    notifyListeners();
  }

  /// Update storage path from settings
  void updateStoragePath(String? path) {
    customStoragePath = path;
  }

  /// Start scanning, called when the camera is shown and no recording.
  void startScanning() {
    isScanning = true;
    scannerController?.start();
    notifyListeners();
  }

  /// Handle detection (MobileScanner 4.x BarcodeCapture)
  Future<void> onDetected(BarcodeCapture capture) async {
    if (!isScanning) return;
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final codeValue = barcode.rawValue;
      if (codeValue != null && codeValue.isNotEmpty) {
        // Stop scanner before starting recording
        await scannerController?.stop();
        isScanning = false;
        lastScannedCode = codeValue;
        notifyListeners();
        await startRecording();
        return;
      }
    }
    // Если ни один код не распознан -- ничего не делаем, продолжаем сканирование.
  }

  /// Start video recording, and save code with video
  Future<void> startRecording() async {
    if (cameraController == null || cameraController!.value.isRecordingVideo) {
      return;
    }

    // Используем customStoragePath, если задан, иначе стандартную папку
    final Directory dir = customStoragePath != null && customStoragePath!.isNotEmpty
        ? Directory(customStoragePath!)
        : await getApplicationDocumentsDirectory();
    
    // Убедимся, что директория существует
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (e) {
        debugPrint('Ошибка создания директории: $e');
        // Fallback на стандартную папку
        final fallbackDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        savedVideoPath = '${fallbackDir.path}/scan_video_$timestamp.mp4';
      }
    }
    
    if (savedVideoPath == null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      savedVideoPath = '${dir.path}/scan_video_$timestamp.mp4';
    }

    try {
      // Wait a bit for scanner to fully stop before starting recording
      await Future.delayed(Duration(milliseconds: 500));
      await cameraController!.startVideoRecording();
      isRecording = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка запуска записи видео: $e');
    }
  }

  /// Stop video recording.
  Future<void> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }
    final file = await cameraController!.stopVideoRecording();
    final File recordedFile = File(file.path);
    
    if (savedVideoPath != null) {
      try {
        await recordedFile.copy(savedVideoPath!);
        debugPrint('Видео сохранено: $savedVideoPath');
      } catch (e) {
        debugPrint('Ошибка копирования видео: $e');
      }
    }
    
    isRecording = false;
    notifyListeners();
    
    // Optionally, persist code+video association in a simple file/db.
    if (savedVideoPath != null) {
      final logFile = File('${savedVideoPath!}.txt');
      await logFile.writeAsString(lastScannedCode ?? '');
    }

    // Restart scanner after recording stops
    await Future.delayed(Duration(milliseconds: 500));
    await scannerController?.start();
  }

  /// Reset scanning after stop.
  Future<void> reset() async {
    lastScannedCode = null;
    savedVideoPath = null;
    isScanning = false;
    isRecording = false;
    // Wait a bit before restarting scanner
    await Future.delayed(Duration(milliseconds: 300));
    await scannerController?.start();
    isScanning = true;
    notifyListeners();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    scannerController?.dispose();
    super.dispose();
  }
}
