import 'package:truthlens_mobile/core/utils/shared_prefs_helper.dart';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';
import 'package:truthlens_mobile/data/model/history/history_response.dart';
import 'package:truthlens_mobile/data/model/history/history_details_response.dart';
import 'package:truthlens_mobile/data/repositories/history_repo.dart';
import 'package:truthlens_mobile/data/data_source/remote/history_api_service.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryApiService _apiService;
  final SharedPrefsHelper _sharedPrefs;

  HistoryRepositoryImpl({
    required HistoryApiService apiService,
    required SharedPrefsHelper sharedPrefs,
  }) : _apiService = apiService,
       _sharedPrefs = sharedPrefs;

  @override
  Future<HistoryResponse> getHistory({int page = 1, int limit = 10}) async {
    final response = await _apiService.getHistory(page: page, limit: limit);
    return response;
  }

  @override
  Future<HistoryDetailResponse?> getHistoryDetail(String id) async {
    final response = await _apiService.getHistoryDetail(id);
    return response;
  }

  @override
  Future<void> deleteHistory(String id) async {
    await _apiService.deleteHistory(id);
  }

  @override
  Future<AnalysisResult?> getAnalysisResult(String id) async {
    final response = await _apiService.getAnalysisResult(id);
    return response;
  }
}
