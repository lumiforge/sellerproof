import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'scan_controller.dart';
import 'scan_screen.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Создаем провайдер настроек и загружаем настройки
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanController()),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sellerproof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScanScreen(),
    );
  }
}
