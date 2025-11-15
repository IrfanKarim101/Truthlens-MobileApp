class ApiConstants {
  // Base URL ---- Dummy URL, replace with actual server IP or domain ----
  static const String baseUrl = 'http://192.168.1.13:8000/';
  // Or IP: 'http://192.168.1.x:8000/api'
  
  // Auth Endpoints
  static const String login = '/auth/login/';
  static const String signup = '/auth/signup/';
  static const String logout = '/auth/logout/';

  //continue with google auth
  static const String googleLogin = '/auth/google/';
  
  // Analysis Endpoints
  static const String analyzeImage = '/analysis/image/';
  static const String analyzeVideo = '/analysis/video/';
  static const String getAnalysisResult = '/analysis/result/';
  
  // History Endpoints
  static const String getHistory = '/history/';
  static const String getHistoryDetail = '/history/detail/';

  static const String getUserStats = '/history/stats/';
  static const String deleteHistory = '/history/delete/';
  

  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
}