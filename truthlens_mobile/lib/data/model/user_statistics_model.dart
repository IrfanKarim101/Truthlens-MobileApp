import 'package:equatable/equatable.dart';

class UserStatistics extends Equatable {
  final int totalScans;
  final int authenticScans;
  final int deepfakeScans;
  final int todayScans;
  final int weekScans;
  final int monthScans;
  final double averageConfidence;
  final List<DailyStats>? dailyStats;

  const UserStatistics({
    required this.totalScans,
    required this.authenticScans,
    required this.deepfakeScans,
    this.todayScans = 0,
    this.weekScans = 0,
    this.monthScans = 0,
    this.averageConfidence = 0.0,
    this.dailyStats,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalScans: json['total_scans'] ?? 0,
      authenticScans: json['authentic_scans'] ?? 0,
      deepfakeScans: json['deepfake_scans'] ?? 0,
      todayScans: json['today_scans'] ?? 0,
      weekScans: json['week_scans'] ?? 0,
      monthScans: json['month_scans'] ?? 0,
      averageConfidence: (json['average_confidence'] ?? 0).toDouble(),
      dailyStats: json['daily_stats'] != null
          ? (json['daily_stats'] as List)
              .map((stat) => DailyStats.fromJson(stat))
              .toList()
          : null,
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
      'daily_stats': dailyStats?.map((stat) => stat.toJson()).toList(),
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
        dailyStats,
      ];
}

class DailyStats extends Equatable {
  final DateTime date;
  final int scans;
  final int authentic;
  final int deepfake;

  const DailyStats({
    required this.date,
    required this.scans,
    required this.authentic,
    required this.deepfake,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date']),
      scans: json['scans'] ?? 0,
      authentic: json['authentic'] ?? 0,
      deepfake: json['deepfake'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'scans': scans,
      'authentic': authentic,
      'deepfake': deepfake,
    };
  }

  @override
  List<Object?> get props => [date, scans, authentic, deepfake];
}