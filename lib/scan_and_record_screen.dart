import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scan_and_record_controller.dart';

/// Screen that handles scanning barcodes + video recording.
class ScanAndRecordScreen extends StatefulWidget {
  const ScanAndRecordScreen({super.key});

  @override
  State<ScanAndRecordScreen> createState() => _ScanAndRecordScreenState();
}

class _ScanAndRecordScreenState extends State<ScanAndRecordScreen> {
  late ScanAndRecordController controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      controller = Provider.of<ScanAndRecordController>(context, listen: false);
      await controller.initialize();
      controller.startScanning(); // Start scanning after initialization
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<ScanAndRecordController>(context);
    if (!controller.cameraReady) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Show scanner when not recording
          if (!controller.isRecording &&
              (controller.isScanning || controller.lastScannedCode == null))
            MobileScanner(
              controller: controller.scannerController,
              fit: BoxFit.cover,
              onDetect: (BarcodeCapture capture) {
                controller.onDetected(capture);
              },
            ),
          // Show camera preview when recording
          if (controller.isRecording && controller.cameraController != null)
            CameraPreview(controller.cameraController!),
          // Scanner overlay
          if (!controller.isRecording) ScannerOverlay(),
          // Video recording overlay status
          if (controller.isRecording)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.red,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Recording...',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // For demo, provide a stop record button if recording.
      floatingActionButton: controller.isRecording
          ? FloatingActionButton(
              child: Icon(Icons.stop),
              backgroundColor: Colors.red,
              onPressed: () async {
                await controller.stopRecording();
                await controller.reset();
              },
            )
          : null,
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
                  'Наведите камеру на QR или штрих-код, чтобы начать запись видео',
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
