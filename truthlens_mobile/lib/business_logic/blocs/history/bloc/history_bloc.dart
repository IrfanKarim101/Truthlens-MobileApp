import 'package:bloc/bloc.dart';
import 'package:truthlens_mobile/data/repositories/history_repo.dart';
import 'package:truthlens_mobile/data/model/history/history_item.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMore = true;

  HistoryBloc({required HistoryRepository historyRepository})
    : _historyRepository = historyRepository,
      super(HistoryInitial()) {
    on<HistoryFetched>(_onFetched);
    on<HistoryFetchedMore>(_onFetchedMore);
    on<HistoryRefreshed>(_onRefreshed);
  }

  Future<void> _onFetched(
    HistoryFetched event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final page = event.page;
      final limit = event.limit;
      final response = await _historyRepository.getHistory(
        page: page,
        limit: limit,
      );
      _currentPage = response.currentPage;
      _limit = limit;
      _hasMore = response.hasMore || response.currentPage < response.totalPages;
      emit(
        HistoryLoadSuccess(
          items: response.items,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }

  Future<void> _onFetchedMore(
    HistoryFetchedMore event,
    Emitter<HistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is HistoryLoadSuccess && _hasMore) {
      try {
        final nextPage = _currentPage + 1;
        final response = await _historyRepository.getHistory(
          page: nextPage,
          limit: _limit,
        );
        _currentPage = response.currentPage;
        _hasMore =
            response.hasMore || response.currentPage < response.totalPages;
        final updatedItems = List<HistoryItem>.from(currentState.items)
          ..addAll(response.items);
        emit(
          HistoryLoadSuccess(
            items: updatedItems,
            currentPage: response.currentPage,
            totalPages: response.totalPages,
            hasMore: _hasMore,
          ),
        );
      } catch (e) {
        emit(HistoryFailure(e.toString()));
      }
    }
  }

  Future<void> _onRefreshed(
    HistoryRefreshed event,
    Emitter<HistoryState> emit,
  ) async {
    _currentPage = 1;
    add(HistoryFetched(page: 1, limit: _limit));
  }
}
