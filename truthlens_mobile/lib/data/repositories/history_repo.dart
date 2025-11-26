import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';
import 'package:truthlens_mobile/data/model/history/history_response.dart';
import 'package:truthlens_mobile/data/model/history/history_details_response.dart';

abstract class HistoryRepository {
  Future<HistoryResponse> getHistory({int page = 1, int limit = 10});
  Future<HistoryDetailResponse?> getHistoryDetail(String id);
  Future<void> deleteHistory(String id);
   Future<AnalysisResult?> getAnalysisResult(String id);
}
