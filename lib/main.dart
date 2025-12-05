import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sellerproof/injection_container.dart' as di;
import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/presentation/screens/auth/login_screen.dart';
import 'package:sellerproof/presentation/screens/scan_screen/scan_controller.dart';
import 'package:sellerproof/presentation/screens/scan_screen/scan_screen.dart';

import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupLocator();
  // Создаем провайдер настроек и загружаем настройки
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  // Check auth status
  final authProvider = di.sl<AuthProvider>();
  await authProvider.checkAuthStatus();
  final initialScreen = authProvider.user != null
      ? const ScanScreen()
      : const LoginScreen();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanController()),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => authProvider),
      ],
      child: MyApp(home: initialScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({super.key, required this.home});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sellerproof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: home,
    );
  }
}
