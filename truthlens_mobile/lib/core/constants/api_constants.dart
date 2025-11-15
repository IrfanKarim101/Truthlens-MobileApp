class ApiConstants {
  // Base URL ---- Dummy URL, replace with actual server IP or domain ----
  static const String baseUrl = 'http://192.168.1.19:8000/';
  
  
  // Auth Endpoints
  static const String login = '/auth/login/';
  static const String signup = '/auth/signup/';
  static const String logout = '/auth/logout/';

  //continue with google auth
  static const String googleLogin = '/auth/google/';
  
  // Analysis Endpoints
  static const String analyzeImage = '/auth/predict-image/';
  static const String analyzeVideo = '/auth/predict-video/';
  
  // History Endpoints
  static const String getHistory = '/history/';
  static const String getHistoryDetail = '/history/detail/';

  static const String getUserStats = '/history/stats/';
  static const String deleteHistory = '/history/delete/';
  

  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
}