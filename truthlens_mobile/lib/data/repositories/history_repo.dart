import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';

abstract class HistoryRepository {
  Future<List<AnalysisResult>> getHistory();
  Future<AnalysisResult?> getHistoryDetail(String id);
  Future<void> deleteHistory(String id);
}