import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:truthlens_mobile/data/repositories/analysis_repo.dart';
part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisRepository _analysisRepository;
  AnalysisBloc({required AnalysisRepository analysisRepository})
    : _analysisRepository = analysisRepository,
      super(AnalysisInitial()) {
    on<AnalyzeImage>(_onAnalyzeImage);
    on<AnalyzeVideo>(_onAnalyzeVideo);
    on<AnalysisProgressUpdate>(_onAnalysisProgressUpdate);
    on<AnalysisCompleted>(_onAnalysisCompleted);
    on<AnalysisError>(_onAnalysisError);
  }

  Future<void> _onAnalyzeImage(
    AnalyzeImage event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      // The repository method would internally handle the API call and progress reporting.
      // For now, we'll assume it returns a result string upon completion.
      final result = await _analysisRepository.analyzeImage(
        File(event.imagePath),

      );
      add(
        AnalysisCompleted(result.toString()),
      ); // Assuming result is convertible to string
    } catch (e) {
      add(AnalysisError(e.toString()));
    }
  }

  Future<void> _onAnalyzeVideo(
    AnalyzeVideo event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final result = await _analysisRepository.analyzeVideo(
        File(event.videoPath), // The repository method would internally handle the API call and progress reporting.

      );
      add(AnalysisCompleted(result.toString()));
    } catch (e) {
      add(AnalysisError(e.toString()));
    }
  }

  void _onAnalysisProgressUpdate(
    AnalysisProgressUpdate event,
    Emitter<AnalysisState> emit,
  ) {
    emit(AnalysisProgress(event.progress));
  }

  void _onAnalysisCompleted(
    AnalysisCompleted event,
    Emitter<AnalysisState> emit,
  ) {
    emit(AnalysisSuccess(event.result));
  }

  void _onAnalysisError(AnalysisError event, Emitter<AnalysisState> emit) {
    emit(AnalysisFailure(event.error));
  }
}
