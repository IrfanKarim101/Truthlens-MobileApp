
import 'package:truthlens_mobile/core/utils/shared_prefs_helper.dart';
import 'package:truthlens_mobile/data/data_source/remote/analysis_api_service.dart';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';
import 'package:truthlens_mobile/data/repositories/analysis_repo.dart';
import 'dart:io';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisApiService _apiService;
  final SharedPrefsHelper _sharedPrefs;

  AnalysisRepositoryImpl({
    required AnalysisApiService apiService,
    required SharedPrefsHelper sharedPrefs,
  })  : _apiService = apiService,
        _sharedPrefs = sharedPrefs;

  @override
  Future<AnalysisResult> analyzeImage(File imageFile) async {
    return await _apiService.analyzeImage(imageFile);
  }

  @override
  Future<AnalysisResult> analyzeVideo(File videoFile) async {
    return await _apiService.analyzeVideo(videoFile);
  }

  @override
  Future<AnalysisResult?> getAnalysisById(String id) async {
    // TODO: Implement
    return null;
  }
}