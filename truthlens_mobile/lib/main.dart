import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_bloc.dart';
import 'package:truthlens_mobile/core/injection_container.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';
import 'package:truthlens_mobile/presentation/screens/about/about_us.dart';
import 'package:truthlens_mobile/presentation/screens/auth/login_screen.dart';
import 'package:truthlens_mobile/presentation/screens/auth/signup_screen.dart';
import 'package:truthlens_mobile/presentation/screens/history/analysis_report.dart';
import 'package:truthlens_mobile/presentation/screens/history/history.dart';
import 'package:truthlens_mobile/presentation/screens/home/home_screen.dart';
import 'package:truthlens_mobile/presentation/screens/splash/splash_screen.dart';
import 'package:truthlens_mobile/presentation/screens/test/test_auth.dart';
import 'package:truthlens_mobile/presentation/screens/upload/image_upload.dart';
import 'package:truthlens_mobile/presentation/screens/upload/video_upload.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  // await initializeDependencies();

  runApp(const TruthLensApp());
}

class TruthLensApp extends StatelessWidget {
  const TruthLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC - Available throughout the app
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        // Add other global BLoCs here if needed
      ],
      child: MaterialApp(
        title: 'TruthLens',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Initial route
        home: const SplashScreen(),

        // Named routes
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
          '/test-auth': (context) => const AuthTestScreen(),
        },

        // Route generator for dynamic routes
        onGenerateRoute: (settings) {
          // Handle routes with parameters
          if (settings.name == '/report') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => AnalysisReportScreen(
                isAuthentic: args?['isAuthentic'] ?? true,
                confidence: args?['confidence'] ?? 98,
                fileName: args?['fileName'] ?? 'file.jpg',
                // ... other parameters
              ),
            );
          }

          return null;
        },
      ),
    );
  }
}
