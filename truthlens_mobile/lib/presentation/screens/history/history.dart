import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';

class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            'Analysis History',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'View all your scans',
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

                // Statistics Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              count: '8',
                              label: 'Total Scans',
                              color: Colors.white,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            _buildStatItem(
                              count: '5',
                              label: 'Authentic',
                              color: Colors.greenAccent,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            _buildStatItem(
                              count: '3',
                              label: 'Deepfakes',
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // History List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      _buildHistoryItem(
                        fileName: 'portrait_image.jpg',
                        isImage: true,
                        isAuthentic: true,
                        confidence: '98% confidence',
                        timeAgo: '3 hours ago', onTap: () { 
                          Navigator.pushNamed(context, AppRoutes.analysisReport);
                         },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'video_sample.mp4',
                        isImage: false,
                        isAuthentic: false,
                        confidence: '87% confidence',
                        timeAgo: '5 hours ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'group_photo.jpg',
                        isImage: true,
                        isAuthentic: true,
                        confidence: '95% confidence',
                        timeAgo: '1 day ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'interview_clip.mp4',
                        isImage: false,
                        isAuthentic: true,
                        confidence: '92% confidence',
                        timeAgo: '1 day ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'profile_pic.jpg',
                        isImage: true,
                        isAuthentic: false,
                        confidence: '78% confidence',
                        timeAgo: '2 days ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'family_video.mp4',
                        isImage: false,
                        isAuthentic: true,
                        confidence: '96% confidence',
                        timeAgo: '3 days ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'selfie_001.jpg',
                        isImage: true,
                        isAuthentic: true,
                        confidence: '99% confidence',
                        timeAgo: '4 days ago', onTap: () {  },
                      ),
                      const SizedBox(height: 12),

                      _buildHistoryItem(
                        fileName: 'presentation.mp4',
                        isImage: false,
                        isAuthentic: false,
                        confidence: '82% confidence',
                        timeAgo: '5 days ago', onTap: () {  },
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

  Widget _buildStatItem({
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String fileName,
    required bool isImage,
    required bool isAuthentic,
    required String confidence,
    required String timeAgo,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isAuthentic
                            ? Colors.greenAccent.withOpacity(0.15)
                            : Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isAuthentic
                              ? Colors.greenAccent.withOpacity(0.3)
                              : Colors.redAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isAuthentic
                            ? Icons.check_circle_outline
                            : Icons.warning_amber_outlined,
                        color: isAuthentic
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // File Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isImage
                                    ? Icons.image_outlined
                                    : Icons.videocam_outlined,
                                color: Colors.white.withOpacity(0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  fileName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isAuthentic
                                ? 'Authentic • $confidence'
                                : 'Deepfake Detected • $confidence',
                            style: TextStyle(
                              fontSize: 13,
                              color: isAuthentic
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Arrow Icon
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withOpacity(0.4),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
