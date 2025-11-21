import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';

class AnalysisReportScreen extends StatelessWidget {
  final AnalysisResult? result;

  const AnalysisReportScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final isAuthentic = result?.isAuthentic ?? true;
    final confidence = result?.confidence ?? 98;
    final fileName = result?.fileInfo.name ?? 'portrait_image.jpg';
    final fileSize = result?.fileInfo.size ?? '2.4 MB';
    final resolution = result?.fileInfo.resolution ?? '1920x1080';
    final analysisTime = '${result?.analysisTime.toStringAsFixed(1) ?? '1.2'}s';
    final scannedTime = result?.timeAgo ?? '2 hours ago';
    final scannedDate =
        result?.timestamp.toIso8601String() ?? 'Nov 4, 2025 at 2:30 PM';
    final metrics =
        result?.metrics.allMetrics ??
        {
          'Face Detection': 99,
          'Skin Texture Analysis': 97,
          'Eye Movement': 98,
          'Lighting Consistency': 96,
        };
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
                Colors.purple.withOpacity(0.1),
                Colors.purple.withOpacity(0.3),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analysis Report',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Detailed Results',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      // Result Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Status Icon
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: (result?.isAuthentic ?? true)
                                        ? Colors.greenAccent.withOpacity(0.2)
                                        : Colors.redAccent.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: (result?.isAuthentic ?? true)
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    (result?.isAuthentic ?? true)
                                        ? Icons.check_circle
                                        : Icons.warning_amber,
                                    color: (result?.isAuthentic ?? true)
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Status Text
                                Text(
                                  (result?.isAuthentic ?? true)
                                      ? 'Authentic'
                                      : 'Deepfake Detected',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: (result?.isAuthentic ?? true)
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Confidence
                                Text(
                                  '$confidence% Confidence',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Progress Bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: confidence / 100,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.1,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      (result?.isAuthentic ?? true)
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // File Information
                      _buildSectionCard(
                        icon: Icons.insert_drive_file_outlined,
                        title: 'File Information',
                        children: [
                          _buildInfoRow('File Name', fileName),
                          const SizedBox(height: 12),
                          _buildInfoRow('File Size', fileSize),
                          const SizedBox(height: 12),
                          _buildInfoRow('Resolution', resolution),
                          const SizedBox(height: 12),
                          _buildInfoRow('Analysis Time', analysisTime),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Scan Details
                      _buildSectionCard(
                        icon: Icons.query_stats_outlined,
                        title: 'Scan Details',
                        children: [
                          _buildInfoRow(
                            'Scanned',
                            scannedTime,
                            icon: Icons.access_time,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Date',
                            scannedDate,
                            icon: Icons.calendar_today,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Analysis Metrics
                      _buildSectionCard(
                        icon: Icons.analytics_outlined,
                        title: 'Analysis Metrics',
                        children: metrics.entries.map((entry) {
                          return Column(
                            children: [
                              _buildMetricRow(entry.key, entry.value),
                              if (entry.key != metrics.keys.last)
                                const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Recommendation
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isAuthentic
                                  ? Colors.greenAccent.withOpacity(0.1)
                                  : Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isAuthentic
                                    ? Colors.greenAccent.withOpacity(0.3)
                                    : Colors.redAccent.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: isAuthentic
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Recommendation',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isAuthentic
                                      ? 'This image appears to be authentic. All indicators suggest natural photographic characteristics with no signs of manipulation.'
                                      : 'This content shows signs of manipulation. We recommend verifying the source and treating this media with caution. Consider additional verification methods.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Back to History Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.purpleAccent.shade100,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlueAccent.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Back to History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.lightBlueAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white.withOpacity(0.5), size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, int percentage) {
    Color color;
    IconData icon;

    if (percentage >= 95) {
      color = Colors.greenAccent;
      icon = Icons.face_outlined;
    } else if (percentage >= 90) {
      color = Colors.lightBlueAccent;
      icon = Icons.texture_outlined;
    } else if (percentage >= 85) {
      color = Colors.purpleAccent.shade100;
      icon = Icons.visibility_outlined;
    } else {
      color = Colors.yellowAccent;
      icon = Icons.wb_sunny_outlined;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
