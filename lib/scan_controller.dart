import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

/// Controller for scanning logic only.
class ScanController extends ChangeNotifier {
  MobileScannerController? scannerController;
  bool scannerReady = false;
  bool isScanning = false;
  String? lastScannedCode;

  /// Call this when initializing the scanner screen.
  Future<void> initialize() async {
    // Check if already initialized
    if (scannerReady) return;

    // Initialize scanner controller with autoStart disabled
    scannerController = MobileScannerController(autoStart: false);

    scannerReady = true;
    notifyListeners();
  }

  /// Start scanning
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
        // Stop scanner
        await scannerController?.stop();
        isScanning = false;
        lastScannedCode = codeValue;
        notifyListeners();
        return;
      }
    }
  }

  /// Reset scanning
  void reset() {
    lastScannedCode = null;
    isScanning = false;
    notifyListeners();
  }

  /// Resume scanning after recording
  void resumeScanning() {
    lastScannedCode = null;
    isScanning = true;

    // Используем addPostFrameCallback с задержкой для безопасного запуска сканера
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Дополнительная задержка, чтобы убедиться, что контроллер готов
      Future.delayed(const Duration(milliseconds: 500), () {
        scannerController?.start();
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    scannerController?.dispose();
    super.dispose();
  }
}
