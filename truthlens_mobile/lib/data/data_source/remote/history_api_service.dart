

import 'package:truthlens_mobile/core/constants/api_constants.dart';
import 'package:truthlens_mobile/core/errors/exceptions.dart';
import 'package:truthlens_mobile/core/network/dio_client.dart';
import 'package:truthlens_mobile/data/model/history/delete_history.dart';
import 'package:truthlens_mobile/data/model/history/history_details_response.dart';
import 'package:truthlens_mobile/data/model/history/history_response.dart';
import 'package:truthlens_mobile/data/model/history/history_stats.dart';

class HistoryApiService {
  final DioClient _dioClient;

  HistoryApiService(this._dioClient);

  // Get all history
  Future<HistoryResponse> getHistory({
    int page = 1,
    int limit = 20,
    String? filter, // 'all', 'authentic', 'deepfake'
    String? sortBy, // 'date', 'confidence', 'name'
    String? order, // 'asc', 'desc'
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (filter != null) 'filter': filter,
        if (sortBy != null) 'sort_by': sortBy,
        if (order != null) 'order': order,
      };

      final response = await _dioClient.get(
        ApiConstants.getHistory,
        queryParameters: queryParams,
      );

      return HistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Get history detail by ID
  Future<HistoryDetailResponse> getHistoryDetail(String id) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.getHistoryDetail}/$id',
      );

      return HistoryDetailResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Get history statistics
  Future<HistoryStatistics> getStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getUserStats,
      );

      return HistoryStatistics.fromJson(response.data['data'] ?? {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Delete history item
  Future<DeleteHistoryResponse> deleteHistory(String id) async {
    try {
      final response = await _dioClient.delete(
        '${ApiConstants.deleteHistory}/$id',
      );

      return DeleteHistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Delete multiple history items
  Future<DeleteHistoryResponse> deleteMultipleHistory(List<String> ids) async {
    try {
      final response = await _dioClient.post(
        '${ApiConstants.deleteHistory}/bulk',
        data: {'ids': ids},
      );

      return DeleteHistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Clear all history
  Future<DeleteHistoryResponse> clearAllHistory() async {
    try {
      final response = await _dioClient.delete(
        '${ApiConstants.deleteHistory}/all',
      );

      return DeleteHistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Search history
  Future<HistoryResponse> searchHistory({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.getHistory}/search',
        queryParameters: {
          'query': query,
          'page': page,
          'limit': limit,
        },
      );

      return HistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Get history by date range
  Future<HistoryResponse> getHistoryByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.getHistory}/date-range',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'page': page,
          'limit': limit,
        },
      );

      return HistoryResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Export history as CSV/JSON
  Future<String> exportHistory({
    String format = 'json', // 'json' or 'csv'
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.getHistory}/export',
        queryParameters: {
          'format': format,
        },
      );

      return response.data['data']['download_url'] ?? '';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}