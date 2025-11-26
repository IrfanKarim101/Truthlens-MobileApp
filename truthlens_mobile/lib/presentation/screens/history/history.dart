import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';
import 'package:truthlens_mobile/business_logic/blocs/history/bloc/history_bloc.dart';
import 'package:truthlens_mobile/core/injection_container.dart';

class AnalysisHistoryScreen extends StatefulWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  State<AnalysisHistoryScreen> createState() => _AnalysisHistoryScreenState();
}

class _AnalysisHistoryScreenState extends State<AnalysisHistoryScreen> {
  late final HistoryBloc _historyBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _historyBloc = getIt<HistoryBloc>();
    _historyBloc.add(HistoryFetched(page: 1, limit: 10));

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _historyBloc.add(HistoryFetchedMore());
    }
  }

  @override
  void dispose() {
    _historyBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<HistoryBloc>.value(
        value: _historyBloc,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
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
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Analysis History',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'View all your scans',
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // History List
                  Expanded(
                    child: BlocBuilder<HistoryBloc, HistoryState>(
                      builder: (context, state) {
                        if (state is HistoryLoading || state is HistoryInitial) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is HistoryLoadSuccess) {
                          final items = state.items;
                          if (items.isEmpty) {
                            return const Center(child: Text('No history yet', style: TextStyle(color: Colors.white)));
                          }
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            itemCount: items.length + (state.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              final it = items[index];
                              return Column(
                                children: [
                                  _buildHistoryItem(
                                    fileName: it.fileName,
                                    isImage: it.isImage,
                                    isAuthentic: it.isAuthentic,
                                    confidence: it.confidenceText,
                                    timeAgo: it.timeAgo,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.analysisReport,
                                        arguments: it,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          );
                        }
                        if (state is HistoryFailure) {
                          return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                        color: isAuthentic ? Colors.greenAccent : Colors.redAccent,
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
                                isImage ? Icons.image_outlined : Icons.videocam_outlined,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  fileName,
                                  style: const TextStyle(
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
                            isAuthentic ? 'Authentic • $confidence' : 'Deepfake Detected • $confidence',
                            style: TextStyle(
                              fontSize: 13,
                              color: isAuthentic ? Colors.greenAccent : Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Icon(Icons.chevron_right, color: Colors.white38, size: 24),
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
