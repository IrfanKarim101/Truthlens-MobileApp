import 'package:flutter/material.dart';
import 'package:truthlens_mobile/presentation/screens/about/about_us.dart';
import 'package:truthlens_mobile/presentation/screens/auth/login_screen.dart';
import 'package:truthlens_mobile/presentation/screens/home/home_screen.dart';
import 'package:truthlens_mobile/presentation/screens/splash/splash_screen.dart';
import 'package:truthlens_mobile/presentation/screens/upload/image_upload.dart';
import 'package:truthlens_mobile/presentation/screens/upload/video_upload.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AboutScreen(),
    );
  }
}
