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
    scannerController = MobileScannerController(autoStart: false);
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back),
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    cameraReady = true;
    notifyListeners();
  }

  void updateStoragePath(String? path) {
    customStoragePath = path;
  }

  void startScanning() {
    isScanning = true;
    scannerController?.start();
    notifyListeners();
  }

  Future<void> onDetected(BarcodeCapture capture) async {
    if (!isScanning) return;
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final codeValue = barcode.rawValue;
      if (codeValue != null && codeValue.isNotEmpty) {
        await scannerController?.stop();
        isScanning = false;
        lastScannedCode = codeValue;
        notifyListeners();
        await startRecording();
        return;
      }
    }
  }

  /// Start video recording, file will be named after code
  Future<void> startRecording() async {
    if (cameraController == null || cameraController!.value.isRecordingVideo) {
      return;
    }
    if (lastScannedCode == null) {
      debugPrint('Нет кода для имени файла');
      return;
    }
    final Directory dir = customStoragePath != null && customStoragePath!.isNotEmpty
        ? Directory(customStoragePath!)
        : await getApplicationDocumentsDirectory();
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (e) {
        debugPrint('Ошибка создания директории: $e');
        final fallbackDir = await getApplicationDocumentsDirectory();
        savedVideoPath = '${fallbackDir.path}/${lastScannedCode!}.mp4';
      }
    }
    if (savedVideoPath == null) {
      savedVideoPath = '${dir.path}/${lastScannedCode!}.mp4';
    }
    try {
      await Future.delayed(Duration(milliseconds: 500));
      await cameraController!.startVideoRecording();
      isRecording = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка запуска записи видео: $e');
    }
  }

  /// Stop and name video by code
  Future<void> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }
    final file = await cameraController!.stopVideoRecording();
    final File recordedFile = File(file.path);
    if (savedVideoPath != null) {
      try {
        await recordedFile.copy(savedVideoPath!);
        debugPrint('Видео сохранено с именем: $savedVideoPath');
        // optionally: удалить временный файл
        if (recordedFile.path != savedVideoPath) {
          await recordedFile.delete();
        }
      } catch (e) {
        debugPrint('Ошибка копирования видео: $e');
      }
    }
    isRecording = false;
    notifyListeners();
    if (savedVideoPath != null && lastScannedCode != null) {
      final logFile = File('${savedVideoPath!}.txt');
      await logFile.writeAsString(lastScannedCode ?? '');
    }
    await Future.delayed(Duration(milliseconds: 500));
    await scannerController?.start();
  }

  Future<void> reset() async {
    lastScannedCode = null;
    savedVideoPath = null;
    isScanning = false;
    isRecording = false;
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
