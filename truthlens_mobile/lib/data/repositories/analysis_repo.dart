import 'dart:io';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';

abstract class AnalysisRepository {
  Future<AnalysisResult> analyzeImage(File imageFile);
  Future<AnalysisResult> analyzeVideo(File videoFile);
  Future<AnalysisResult?> getAnalysisById(String id);
}
