import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../services/tts_service.dart';

/// Controller for scanning logic only.
class ScanController extends ChangeNotifier {
  MobileScannerController? scannerController;
  bool scannerReady = false;
  bool isScanning = false;
  String? lastScannedCode;
  final TtsService _ttsService = TtsService();

  Future<void> initialize() async {
    debugPrint('🔧 ScanController: initialize called');
    if (scannerReady) {
      debugPrint('✅ ScanController: Already initialized');
      return;
    }
    try {
      await _ttsService.initialize();
      scannerController = MobileScannerController(
        autoStart: false,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: const [
          BarcodeFormat.qrCode,
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.code93,
          BarcodeFormat.dataMatrix,
          BarcodeFormat.itf,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
        ],
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: false,
      );
      scannerReady = true;
      notifyListeners();
      debugPrint('✅ ScanController: Initialized successfully');
    } catch (e) {
      debugPrint('❌ ScanController: Initialization error: $e');
    }
  }

  void startScanning() {
    debugPrint('▶️ ScanController: startScanning called');
    isScanning = true;
    scannerController?.start();
    notifyListeners();
    debugPrint('✅ ScanController: Scanner started');
  }

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
        await scannerController?.stop();
        isScanning = false;
        lastScannedCode = codeValue;
        notifyListeners();
        // Вместо speakLastFourDigits теперь один шаблон записи
        await _ttsService.speakRecordWithCode(codeValue);
        debugPrint('⏸️ ScanController: Scanner stopped after detection');
        return;
      }
    }
  }

  void reset() {
    debugPrint('🔄 ScanController: reset called');
    lastScannedCode = null;
    isScanning = false;
    notifyListeners();
    debugPrint('✅ ScanController: Reset complete');
  }

  void resumeScanning() {
    debugPrint('🔄 ScanController: resumeScanning called');
    if (!scannerReady) {
      debugPrint('⚠️ ScanController: Scanner not ready, cannot resume');
      return;
    }
    lastScannedCode = null;
    isScanning = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
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
