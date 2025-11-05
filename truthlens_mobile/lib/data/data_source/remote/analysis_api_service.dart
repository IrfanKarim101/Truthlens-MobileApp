import 'dart:io';

import 'package:dio/dio.dart';
import 'package:truthlens_mobile/core/constants/api_constants.dart';
import 'package:truthlens_mobile/core/errors/exceptions.dart';
import 'package:truthlens_mobile/core/network/dio_client.dart';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';

class AnalysisApiService {
  final DioClient _dioClient;
  
  AnalysisApiService(this._dioClient);
  
  Future<AnalysisResult> analyzeImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });
      
      final response = await _dioClient.postFormData(
        ApiConstants.analyzeImage,
        formData,
      );
      
      return AnalysisResult.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  Future<AnalysisResult> analyzeVideo(File videoFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
      });
      
      final response = await _dioClient.postFormData(
        ApiConstants.analyzeVideo,
        formData,
      );
      
      return AnalysisResult.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}