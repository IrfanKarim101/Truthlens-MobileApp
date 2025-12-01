import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_event.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_state.dart';
import 'dart:ui';
import 'package:truthlens_mobile/business_logic/blocs/history/bloc/history_bloc.dart';
import 'package:truthlens_mobile/core/injection_container.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HistoryBloc _historyBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = getIt<HistoryBloc>();
    _historyBloc.add(HistoryFetched(page: 1, limit: 5));
  }

  @override
  void dispose() {
    _historyBloc.close();
    super.dispose();
  }

  void calculateStats(Map<String, dynamic> response) {
    final results = response['results'] as List<dynamic>;

    int total = response['total_results'] ?? results.length;

    int realCount = 0;
    int fakeCount = 0;

    for (var item in results) {
      if (item['prediction'] == 'real') {
        realCount++;
      } else if (item['prediction'] == 'fake') {
        fakeCount++;
      }
    }

    double realPercent = (realCount / total) * 100;
    double fakePercent = (fakeCount / total) * 100;

    print("Total Scans: $total");
    print("Real: $realCount  (${realPercent.toStringAsFixed(1)}%)");
    print("Fake: $fakeCount  (${fakePercent.toStringAsFixed(1)}%)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<HistoryBloc>(
        create: (_) => _historyBloc,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              // Show loading indicator or similar
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );
            } else {
              // Hide loading indicator
              Navigator.of(context, rootNavigator: true).pop();
            }
            if (state is Unauthenticated) {
              // If user is logged out, navigate to login screen
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          child: Container(
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Truth',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'lens',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.lightBlueAccent,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Deepfake Detection',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            // Logout Button
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
                                  context.read<AuthBloc>().add(
                                    const LogoutRequested(),
                                  );
                                  // Navigator.pushNamed(context, AppRoutes.login);
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Statistics Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.trending_up,
                                count: '247',
                                label: 'Analyzed',
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.check_circle_outline,
                                count: '189',
                                label: 'Authentic',
                                color: Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.warning_amber_outlined,
                                count: '58',
                                label: 'Deepfakes',
                                color: Colors.purpleAccent.shade100,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Analyze Media Section
                        Text(
                          'ANALYZE MEDIA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Upload Image Card
                        _buildUploadCard(
                          icon: Icons.image_outlined,
                          title: 'Upload Image',
                          subtitle: 'Detect deepfakes in photos',
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.3),
                              Colors.blue.withOpacity(0.1),
                            ],
                          ),
                          iconColor: Colors.lightBlueAccent,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.uploadImage);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Upload Video Card
                        _buildUploadCard(
                          icon: Icons.videocam_outlined,
                          title: 'Upload Video',
                          subtitle: 'Analyze video content',
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.withOpacity(0.3),
                              Colors.purple.withOpacity(0.1),
                            ],
                          ),
                          iconColor: Colors.purpleAccent.shade100,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.uploadVideo);
                          },
                        ),

                        const SizedBox(height: 32),

                        // Recent Activity Section
                        Row(
                          children: [
                            Text(
                              'RECENT ACTIVITY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1.2,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.history);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.lightBlueAccent,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Recent Activity List
                        BlocBuilder<HistoryBloc, HistoryState>(
                          builder: (context, state) {
                            if (state is HistoryLoadSuccess) {
                              final items = state.items;

                              if (items.isEmpty) return const SizedBox();

                              // Take only the last 5 items
                              final lastFive = items.length > 5
                                  ? items.sublist(0, 5)
                                  : items;

                              return Column(
                                children: lastFive
                                    .map(
                                      (it) => Column(
                                        children: [
                                          _buildActivityItem(
                                            fileName: it.fileName,
                                            status: it.statusText,
                                            confidence: it.confidenceText,
                                            isAuthentic: it.isAuthentic,
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            }

                            if (state is HistoryLoading ||
                                state is HistoryInitial) {
                              return Column(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }

                            return const SizedBox();
                          },
                        ),

                        const SizedBox(height: 12),

                        // If you want to keep static placeholders when no data, you could fallback here.
                        const SizedBox(height: 32),

                        // About Button
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // TODO: Navigate to about screen
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.about,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'About Truthlens',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 12),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: iconColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
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

  Widget _buildActivityItem({
    required String fileName,
    required String status,
    required String confidence,
    required bool isAuthentic,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isAuthentic
                      ? Colors.greenAccent.withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isAuthentic
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_outlined,
                  color: isAuthentic ? Colors.greenAccent : Colors.redAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$status • $confidence',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.4),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
