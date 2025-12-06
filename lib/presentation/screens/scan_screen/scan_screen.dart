import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';

import 'scan_controller.dart';
import '../packing_camera_screen/packing_camera_screen.dart';
import '../../widgets/app_drawer.dart';

/// Screen that handles QR code scanning.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  ScanController? controller;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('📱 ScanScreen: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller == null) {
      controller = Provider.of<ScanController>(context, listen: false);
      _initializeScanner();
    }
  }

  Future<void> _initializeScanner() async {
    debugPrint('📷 ScanScreen: Initializing scanner');
    await controller!.initialize();

    // Небольшая задержка перед запуском сканера
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      controller!.resumeScanning();
      setState(() {});
      debugPrint('✅ ScanScreen: Scanner started');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (controller == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('📱 ScanScreen: App resumed');
        // Возобновляем сканирование при возврате в приложение
        if (mounted && !_isNavigating) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isNavigating) {
              controller?.resumeScanning();
              debugPrint('✅ ScanScreen: Scanner resumed after app resume');
            }
          });
        }
        break;
      case AppLifecycleState.paused:
        debugPrint('📱 ScanScreen: App paused');
        break;
      default:
        break;
    }
  }

  void _navigateToRecording(String code) {
    if (_isNavigating) {
      debugPrint('⚠️ Already navigating, ignoring');
      return;
    }

    debugPrint('🚀 Navigating to recording with code: $code');
    _isNavigating = true;

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PackingCameraPage(initialCode: code),
          ),
        )
        .then((_) {
          debugPrint('🔙 Returned from recording screen');
          _isNavigating = false;

          // Возобновляем сканирование после возврата
          if (mounted && controller != null) {
            debugPrint('🔄 Resetting and resuming scanner');
            controller!.reset();

            // Даем время камере освободиться
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted && !_isNavigating) {
                controller!.resumeScanning();
                setState(() {});
                debugPrint('✅ Scanner resumed after return');
              }
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ScanController>(context);
    final l = AppLocalizations.of(context)!;

    if (!controller.scannerReady) {
      debugPrint('⏳ Scanner not ready');
      return Scaffold(
        appBar: AppBar(
          // title: SvgPicture.asset(
          //   'assets/images/elephant.svg',
          //   width: 28,
          //   height: 28,
          //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          // ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(l.scannerInitializing),
            ],
          ),
        ),
      );
    }

    // Если код отсканирован, автоматически переходим к записи
    if (controller.lastScannedCode != null &&
        !controller.isScanning &&
        !_isNavigating) {
      final scannedCode = controller.lastScannedCode;
      if (scannedCode != null) {
        debugPrint('📦 Code scanned: $scannedCode, navigating...');
        Future.microtask(() {
          _navigateToRecording(scannedCode);
        });
      }
    }

    debugPrint(
      '🎨 Building ScanScreen - isScanning: ${controller.isScanning}, lastCode: ${controller.lastScannedCode}',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: SvgPicture.asset(
        //   'assets/images/elephant.svg',
        //   width: 28,
        //   height: 28,
        //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Show scanner when scanning
          if (controller.isScanning)
            MobileScanner(
              controller: controller.scannerController,
              fit: BoxFit.cover,
              onDetect: (BarcodeCapture capture) {
                controller.onDetected(capture);
              },
            ),

          // Показываем черный экран если не сканируем
          if (!controller.isScanning && controller.lastScannedCode == null)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      l.preparingCamera,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
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
                    Text(
                      l.codeFoundTitle,
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
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          l.startingRecording,
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
    debugPrint('🗑️ ScanScreen: dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  l.aimCameraHelper,
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
