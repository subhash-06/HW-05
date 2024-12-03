import 'package:flutter/material.dart';
import 'package:hw5_quiz_app/services/database.service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './components/quiz_setup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeDatabase();
  runApp(const MyApp());
}

/// Initialize the SQLite database with FFI support
void _initializeDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  DatabaseService.instance.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customizable Quiz App',
      theme: _buildTheme(),
      home: const QuizSetupScreen(),
    );
  }

  /// Builds the application theme
  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      useMaterial3: true,
      brightness: Brightness.light, // Light theme
    );
  }
}
