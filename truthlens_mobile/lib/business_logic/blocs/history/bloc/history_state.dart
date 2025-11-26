part of 'history_bloc.dart';

sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryLoadSuccess extends HistoryState {
  final List<HistoryItem> items;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  HistoryLoadSuccess({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

final class HistoryFailure extends HistoryState {
  final String message;
  HistoryFailure(this.message);
}
