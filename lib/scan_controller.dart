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
    debugPrint('🔧 ScanController: initialize called');

    // Check if already initialized
    if (scannerReady) {
      debugPrint('✅ ScanController: Already initialized');
      return;
    }

    try {
      // Initialize scanner controller with autoStart disabled
      scannerController = MobileScannerController(autoStart: false);

      scannerReady = true;
      notifyListeners();
      debugPrint('✅ ScanController: Initialized successfully');
    } catch (e) {
      debugPrint('❌ ScanController: Initialization error: $e');
    }
  }

  /// Start scanning
  void startScanning() {
    debugPrint('▶️ ScanController: startScanning called');
    isScanning = true;
    scannerController?.start();
    notifyListeners();
    debugPrint('✅ ScanController: Scanner started');
  }

  /// Handle detection (MobileScanner 4.x BarcodeCapture)
  Future<void> onDetected(BarcodeCapture capture) async {
    if (!isScanning) {
      debugPrint('⚠️ ScanController: Not scanning, ignoring detection');
      return;
    }

    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final codeValue = barcode.rawValue;
      if (codeValue != null && codeValue.isNotEmpty) {
        debugPrint('📦 ScanController: Code detected: $codeValue');

        // Stop scanner
        await scannerController?.stop();
        isScanning = false;
        lastScannedCode = codeValue;
        notifyListeners();

        debugPrint('⏸️ ScanController: Scanner stopped after detection');
        return;
      }
    }
  }

  /// Reset scanning
  void reset() {
    debugPrint('🔄 ScanController: reset called');
    lastScannedCode = null;
    isScanning = false;
    notifyListeners();
    debugPrint('✅ ScanController: Reset complete');
  }

  /// Resume scanning after recording
  void resumeScanning() {
    debugPrint('🔄 ScanController: resumeScanning called');

    if (!scannerReady) {
      debugPrint('⚠️ ScanController: Scanner not ready, cannot resume');
      return;
    }

    lastScannedCode = null;
    isScanning = true;

    // Используем addPostFrameCallback для безопасного запуска сканера
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Дополнительная задержка, чтобы убедиться, что контроллер готов
      Future.delayed(const Duration(milliseconds: 500), () {
        try {
          scannerController?.start();
          notifyListeners();
          debugPrint('✅ ScanController: Scanner resumed and started');
        } catch (e) {
          debugPrint('❌ ScanController: Error resuming scanner: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    debugPrint('🗑️ ScanController: dispose called');
    scannerController?.dispose();
    super.dispose();
  }
}
