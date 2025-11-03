import 'package:flutter/material.dart';
import 'package:truthlens_mobile/presentation/screens/auth/login_screen.dart';
import 'package:truthlens_mobile/presentation/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TruthLens Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:LoginScreen()
    );
  }
}