import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/data/repositories/history_repo.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';
import 'package:truthlens_mobile/business_logic/blocs/history/bloc/history_bloc.dart';
import 'package:truthlens_mobile/core/injection_container.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryBloc _historyBloc;
  late final ScrollController _scrollController;
  final HistoryRepository historyRepository = getIt<HistoryRepository>();

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
      appBar: AppBar(title: const Text('Analysis History')),
      body: BlocProvider<HistoryBloc>.value(
        value: _historyBloc,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading || state is HistoryInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HistoryLoadSuccess) {
              final items = state.items;
              if (items.isEmpty) {
                return const Center(child: Text('No history yet'));
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: items.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final it = items[index];
                  return ListTile(
                    leading: Icon(it.isImage ? Icons.image : Icons.videocam),
                    title: Text(it.fileName),
                    subtitle: Text(
                      '${it.statusText} • ${it.confidenceText} • ${it.timeAgo}',
                    ),
                    onTap: () async {
                      try {
                        final response = await historyRepository
                            .getAnalysisResult(it.id.toString());

                        if (!mounted) return;

                        if (response != null) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.analysisReport,
                            arguments: response,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to load history details'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  );
                },
              );
            }
            if (state is HistoryFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
