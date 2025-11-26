part of 'history_bloc.dart';

sealed class HistoryEvent {}

final class HistoryFetched extends HistoryEvent {
  final int page;
  final int limit;
  HistoryFetched({this.page = 1, this.limit = 10});
}

final class HistoryFetchedMore extends HistoryEvent {}

final class HistoryRefreshed extends HistoryEvent {}
