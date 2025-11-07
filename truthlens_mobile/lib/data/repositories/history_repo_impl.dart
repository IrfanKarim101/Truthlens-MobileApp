import 'package:truthlens_mobile/core/utils/shared_prefs_helper.dart';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';
import 'package:truthlens_mobile/data/repositories/history_repo.dart';


class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryApiService _apiService;
  final SharedPrefsHelper _sharedPrefs;

  HistoryRepositoryImpl({
    required HistoryApiService apiService,
    required SharedPrefsHelper sharedPrefs,
  })  : _apiService = apiService,
        _sharedPrefs = sharedPrefs;

  @override
  Future<List<AnalysisResult>> getHistory() async {
    // TODO: Implement
    return [];
  }

  @override
  Future<AnalysisResult?> getHistoryDetail(String id) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> deleteHistory(String id) async {
    // TODO: Implement
  }
}

class HistoryApiService {
}