import 'package:flutter/material.dart';
import 'lib/screens/main_shell.dart';

void main() {
  runApp(const TestNavbarApp());
}

class TestNavbarApp extends StatelessWidget {
  const TestNavbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navbar Test',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFAC23A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
