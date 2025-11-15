import 'package:equatable/equatable.dart';

class HistoryStatistics extends Equatable {
  final int totalScans;
  final int authenticScans;
  final int deepfakeScans;
  final int todayScans;
  final int weekScans;
  final int monthScans;
  final double averageConfidence;

  const HistoryStatistics({
    required this.totalScans,
    required this.authenticScans,
    required this.deepfakeScans,
    this.todayScans = 0,
    this.weekScans = 0,
    this.monthScans = 0,
    this.averageConfidence = 0.0,
  });

  factory HistoryStatistics.fromJson(Map<String, dynamic> json) {
    return HistoryStatistics(
      totalScans: json['total_scans'] ?? 0,
      authenticScans: json['authentic_scans'] ?? 0,
      deepfakeScans: json['deepfake_scans'] ?? 0,
      todayScans: json['today_scans'] ?? 0,
      weekScans: json['week_scans'] ?? 0,
      monthScans: json['month_scans'] ?? 0,
      averageConfidence: (json['average_confidence'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_scans': totalScans,
      'authentic_scans': authenticScans,
      'deepfake_scans': deepfakeScans,
      'today_scans': todayScans,
      'week_scans': weekScans,
      'month_scans': monthScans,
      'average_confidence': averageConfidence,
    };
  }

  double get authenticRate {
    if (totalScans == 0) return 0.0;
    return (authenticScans / totalScans) * 100;
  }

  double get deepfakeRate {
    if (totalScans == 0) return 0.0;
    return (deepfakeScans / totalScans) * 100;
  }

  @override
  List<Object?> get props => [
        totalScans,
        authenticScans,
        deepfakeScans,
        todayScans,
        weekScans,
        monthScans,
        averageConfidence,
      ];
}