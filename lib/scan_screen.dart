import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scan_controller.dart';
import 'pages/packing_camera_page.dart';

/// Screen that handles QR code scanning.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanController? controller;
  bool _isNavigating = false; // Флаг для предотвращения множественной навигации

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Инициализация при первом вызове
    if (controller == null) {
      controller = Provider.of<ScanController>(context, listen: false);
      Future.microtask(() async {
        await controller!.initialize();
        controller!.resumeScanning(); // Resume scanning after initialization
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _navigateToRecording(String code) {
    if (_isNavigating) return; // Предотвращаем повторную навигацию

    _isNavigating = true;
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PackingCameraPage(initialCode: code),
          ),
        )
        .then((_) {
          // После возврата сбрасываем флаг навигации
          _isNavigating = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ScanController>(context);

    if (!controller.scannerReady) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Если код отсканирован, автоматически переходим к записи
    if (controller.lastScannedCode != null &&
        !controller.isScanning &&
        !_isNavigating) {
      final scannedCode = controller.lastScannedCode;
      if (scannedCode != null) {
        Future.microtask(() {
          _navigateToRecording(scannedCode);
        });
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Show scanner when not recording
          if (controller.isScanning || controller.lastScannedCode == null)
            MobileScanner(
              controller: controller.scannerController,
              fit: BoxFit.cover,
              onDetect: (BarcodeCapture capture) {
                controller.onDetected(capture);
              },
            ),
          // Scanner overlay
          if (controller.isScanning) const ScannerOverlay(),
          // Show code found message
          if (controller.lastScannedCode != null && !controller.isScanning)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Код найден:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.lastScannedCode ?? '',
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Запуск видеозаписи...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Не dispose контроллер здесь, так как он управляется Provider
    super.dispose();
  }
}

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Center(
            child: Card(
              color: Colors.black.withAlpha(179),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Наведите камеру на QR или штрих-код',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
