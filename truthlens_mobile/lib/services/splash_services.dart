import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';

/// Simple splash helper that decides which route to open after the splash.
///
/// It uses `SharedPreferences` to read a boolean flag `is_authenticated`.
/// - If true -> returns `AppRoutes.home`
/// - If false/absent -> returns `AppRoutes.login`
class SplashService {
  static const String _authKey = 'is_authenticated';

  /// Returns `true` if the user is considered authenticated.
  ///
  /// Currently this reads a simple boolean flag from SharedPreferences.
  /// Replace with token checks or secure storage as needed.
  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_authKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Returns the initial route to navigate to (home or login).
  static Future<String> getInitialRoute() async {
    final auth = await isAuthenticated();
    return auth ? AppRoutes.home : AppRoutes.login;
  }

  /// Helper to set the auth flag (useful for testing/development).
  static Future<void> setAuthenticated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, value);
  }
}
