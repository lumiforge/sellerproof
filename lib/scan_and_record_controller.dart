import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
    // Request storage permissions
    final storageStatus = await Permission.storage.request();
    final manageStorageStatus = await Permission.manageExternalStorage.request();
    
    if (!storageStatus.isGranted && !manageStorageStatus.isGranted) {
      debugPrint('Нет разрешения на хранилище');
    }
    
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

    // Determine directory
    Directory dir;
    if (customStoragePath != null && customStoragePath!.isNotEmpty) {
      dir = Directory(customStoragePath!);
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    // Create directory if needed
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
        debugPrint('Директория создана: ${dir.path}');
      } catch (e) {
        debugPrint('Ошибка создания директории: $e');
        dir = await getApplicationDocumentsDirectory();
        debugPrint('Используется fallback директория: ${dir.path}');
      }
    }

    // Set file path
    savedVideoPath = '${dir.path}/${lastScannedCode!}.mp4';
    debugPrint('Планируемый путь сохранения: $savedVideoPath');

    try {
      await cameraController!.startVideoRecording();
      isRecording = true;
      notifyListeners();
      debugPrint('Запись видео начата');
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
    debugPrint('Видео записано во временный файл: ${file.path}');
    
    if (savedVideoPath != null) {
      try {
        await recordedFile.copy(savedVideoPath!);
        debugPrint('Видео сохранено с именем: $savedVideoPath');
        // optionally: delete temporary file
        if (recordedFile.path != savedVideoPath) {
          await recordedFile.delete();
          debugPrint('Временный файл удален');
        }
      } catch (e) {
        debugPrint('Ошибка копирования видео: $e');
      }
    } else {
      debugPrint('savedVideoPath == null, видео не сохранено!');
    }
    
    isRecording = false;
    notifyListeners();
    
    if (savedVideoPath != null && lastScannedCode != null) {
      final logFile = File('${savedVideoPath!}.txt');
      await logFile.writeAsString(lastScannedCode ?? '');
      debugPrint('Лог-файл создан: ${logFile.path}');
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
