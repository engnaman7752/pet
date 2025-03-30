// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Guardian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white70,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
