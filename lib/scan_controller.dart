import 'package:flutter/foundation.dart';
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

  @override
  void dispose() {
    scannerController?.dispose();
    super.dispose();
  }
}
