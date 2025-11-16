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

  /// Call this when initializing the screen.
  Future<void> initialize() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back),
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    // NOTE: We rely on the MobileScanner widget directly for camera;
    // do NOT double-initialize the camera in controller and widget.
    scannerController = null;
    cameraReady = true;
    notifyListeners();
  }

  /// Start scanning, called when the camera is shown and no recording.
  void startScanning() {
    isScanning = true;
    notifyListeners();
    // Do not call start on scannerController, let widget handle lifecycle
  }

  /// Handle detection (MobileScanner 4.x BarcodeCapture)
  Future<void> onDetected(BarcodeCapture capture) async {
    if (!isScanning) return;
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final codeValue = barcode.rawValue;
      if (codeValue != null && codeValue.isNotEmpty) {
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
    if (cameraController == null || cameraController!.value.isRecordingVideo) return;

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final videoPath = '${dir.path}/scan_video_$timestamp.mp4';

    try {
      await cameraController!.startVideoRecording();
      isRecording = true;
      savedVideoPath = videoPath;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка запуска записи видео: $e');
    }
  }

  /// Stop video recording.
  Future<void> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo)
      return;
    final file = await cameraController!.stopVideoRecording();
    final File recordedFile = File(file.path);
    final File toSaved = await recordedFile.copy(savedVideoPath!);
    isRecording = false;
    notifyListeners();
    // Optionally, persist code+video association in a simple file/db.
    final logFile = File('${savedVideoPath!}.txt');
    await logFile.writeAsString(lastScannedCode ?? '');
  }

  /// Reset scanning after stop.
  void reset() {
    lastScannedCode = null;
    isScanning = false;
    isRecording = false;
    notifyListeners();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    scannerController?.dispose();
    super.dispose();
  }
}
