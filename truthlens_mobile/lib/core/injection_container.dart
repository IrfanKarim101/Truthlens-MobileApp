import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:truthlens_mobile/business_logic/blocs/analysis/bloc/analysis_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/upload/bloc/upload_bloc.dart';
import 'package:truthlens_mobile/core/network/api_intercepter.dart';
import 'package:truthlens_mobile/core/network/dio_client.dart';
import 'package:truthlens_mobile/core/utils/secure_storage_helper.dart';
import 'package:truthlens_mobile/core/utils/shared_prefs_helper.dart';
import 'package:truthlens_mobile/data/data_source/remote/analysis_api_service.dart';
import 'package:truthlens_mobile/data/data_source/remote/auth_api_service.dart';
import 'package:truthlens_mobile/data/repositories/analysis_repo.dart';
import 'package:truthlens_mobile/data/repositories/auth_repo.dart';

// Core


// Data Sources


// Repositories


// BLoCs
import '../../business_logic/blocs/auth/auth_bloc.dart';


// GetIt instance
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==================== EXTERNAL ====================
  
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Flutter Secure Storage
  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // ==================== CORE / SERVICES ====================
  
  // Secure Storage Helper
  getIt.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(getIt<FlutterSecureStorage>()),
  );
  
  // SharedPrefs Helper
  getIt.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(getIt<SharedPreferences>()),
  );
  
  // API Interceptor
  getIt.registerLazySingleton<ApiInterceptor>(
    () => ApiInterceptor(getIt<SecureStorageHelper>()),
  );
  
  // Dio Client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<ApiInterceptor>()),
  );
  
  // ==================== DATA SOURCES ====================
  
  // Auth API Service
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(getIt<DioClient>()),
  );
  
  // Analysis API Service
  getIt.registerLazySingleton<AnalysisApiService>(
    () => AnalysisApiService(getIt<DioClient>()),
  );
  
  // History API Service
  // getIt.registerLazySingleton<HistoryApiService>(
  //   () => HistoryApiService(getIt<DioClient>()),
  // );
  
  // ==================== REPOSITORIES ====================
  
  // Auth Repository
  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     apiService: getIt<AuthApiService>(),
  //     secureStorage: getIt<SecureStorageHelper>(),
  //     sharedPrefs: getIt<SharedPrefsHelper>(),
  //   ),
  // );
  
  // Analysis Repository
  // getIt.registerLazySingleton<AnalysisRepository>(
  //   () => AnalysisRepositoryImpl(
  //     apiService: getIt<AnalysisApiService>(),
  //     sharedPrefs: getIt<SharedPrefsHelper>(),
  //   ),
  // );
  
  // History Repository
  // getIt.registerLazySingleton<HistoryRepository>(
  //   () => HistoryRepositoryImpl(
  //     apiService: getIt<HistoryApiService>(),
  //     sharedPrefs: getIt<SharedPrefsHelper>(),
  //   ),
  // );
  
  // ==================== BLOCS ====================
  
  // Auth BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  
  // Analysis BLoC
  // getIt.registerFactory<AnalysisBloc>(
  //   () => AnalysisBloc(analysisRepository: getIt<AnalysisRepository>()),
  // );
  
  // Upload BLoC
  getIt.registerFactory<UploadBloc>(
    () => UploadBloc(analysisRepository: getIt<AnalysisRepository>(), analysisService: getIt<AnalysisApiService>(),)
  );
  
  // // History BLoC
  // getIt.registerFactory<HistoryBloc>(
  //   () => HistoryBloc(historyRepository: getIt<HistoryRepository>()),
  // );
}

// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}