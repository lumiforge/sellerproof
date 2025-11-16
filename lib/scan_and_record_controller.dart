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
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [
        BarcodeFormat.qrCode,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.dataMatrix,
      ],
    );
    cameraReady = true;
    notifyListeners();
  }

  /// Start scanning, called when the camera is shown and no recording.
  void startScanning() {
    isScanning = true;
    notifyListeners();
    scannerController?.start();
  }

  /// Handle detection
  Future<void> onDetected(BarcodeCapture capture) async {
    if (!isScanning) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode != null &&
        barcode.rawValue != null &&
        barcode.rawValue!.isNotEmpty) {
      isScanning = false;
      lastScannedCode = barcode.rawValue!;
      notifyListeners();
      await startRecording();
    }
    // Else: will keep scanning.
  }

  /// Start video recording, and save code with video
  Future<void> startRecording() async {
    if (cameraController == null || cameraController!.value.isRecordingVideo)
      return;
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final videoPath = '${dir.path}/scan_video_$timestamp.mp4';
    await cameraController!.startVideoRecording();
    isRecording = true;
    savedVideoPath = videoPath;
    notifyListeners();
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
