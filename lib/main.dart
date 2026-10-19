import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const MeuBolsoApp());
}

class MeuBolsoApp extends StatelessWidget {
  const MeuBolsoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeuBolso',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.escuro,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(child: Text('MeuBolso')),
      ),
    );
  }
}
