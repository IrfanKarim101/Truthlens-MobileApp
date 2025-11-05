import 'package:flutter/material.dart';
import 'package:truthlens_mobile/presentation/screens/about/about_us.dart';
import 'package:truthlens_mobile/presentation/screens/auth/login_screen.dart';
import 'package:truthlens_mobile/presentation/screens/auth/signup_screen.dart';
import 'package:truthlens_mobile/presentation/screens/history/analysis_report.dart';
import 'package:truthlens_mobile/presentation/screens/history/history.dart';
import 'package:truthlens_mobile/presentation/screens/home/home_screen.dart';
import 'package:truthlens_mobile/presentation/screens/splash/splash_screen.dart';
import 'package:truthlens_mobile/presentation/screens/upload/image_upload.dart';
import 'package:truthlens_mobile/presentation/screens/upload/video_upload.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';

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
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignUpScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.uploadImage: (_) => const UploadImageScreen(),
        AppRoutes.uploadVideo: (_) => const UploadVideoScreen(),
        AppRoutes.about: (_) => const AboutScreen(),
        AppRoutes.analysisReport: (_) => const AnalysisReportScreen(),
        AppRoutes.history: (_) => const AnalysisHistoryScreen(),
      },
    );
  }
}
