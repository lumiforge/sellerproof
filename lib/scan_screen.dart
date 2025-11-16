import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scan_controller.dart';
import 'pages/packing_camera_page.dart';

/// Screen that handles QR code scanning.
class ScanScreen extends StatefulWidget {
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late ScanController controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      controller = Provider.of<ScanController>(context, listen: false);
      await controller.initialize();
      controller.startScanning(); // Start scanning after initialization
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<ScanController>(context);
    if (!controller.scannerReady) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
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
          if (controller.isScanning) ScannerOverlay(),
          // Show code found message
          if (controller.lastScannedCode != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Код найден:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.lastScannedCode!,
                      style: TextStyle(color: Colors.green, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to recording screen with the scanned code
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PackingCameraPage(
                              initialCode: controller.lastScannedCode!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Начать запись',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
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
              color: Colors.black.withAlpha(179), // 0.7*255=178.5
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
