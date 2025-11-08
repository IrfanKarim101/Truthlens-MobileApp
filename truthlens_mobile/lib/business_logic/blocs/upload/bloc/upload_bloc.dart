import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:truthlens_mobile/data/data_source/remote/analysis_api_service.dart';
import 'package:truthlens_mobile/data/model/analysis/analysis_result.dart';
import 'package:truthlens_mobile/core/errors/exceptions.dart';
import 'package:truthlens_mobile/data/repositories/analysis_repo.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final AnalysisApiService _analysisService;

  UploadBloc({required AnalysisApiService analysisService, required AnalysisRepository analysisRepository})
    : _analysisService = analysisService,
      super(UploadInitial()) {
    on<UploadImageRequested>(_onUploadImage);
    on<UploadVideoRequested>(_onUploadVideo);
    on<UploadProgressChanged>(_onProgressChanged);
    on<UploadCancelled>(_onCancelled);
  }

  Future<void> _onUploadImage(
    UploadImageRequested event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadInProgress(0.0));

    try {
      final result = await _analysisService.analyzeImage(
        event.file,
        onSendProgress: (sent, total) {
          final progress = total > 0 ? sent / total : 0.0;
          add(UploadProgressChanged(progress));
        },
      );

      emit(UploadSuccess(result));
    } catch (e) {
      if (e is TruthLensException) {
        emit(UploadFailure(e));
      } else {
        emit(UploadFailure(UnknownException(e.toString())));
      }
    }
  }

  Future<void> _onUploadVideo(
    UploadVideoRequested event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadInProgress(0.0));

    try {
      final result = await _analysisService.analyzeVideo(
        event.file,
        onSendProgress: (sent, total) {
          final progress = total > 0 ? sent / total : 0.0;
          add(UploadProgressChanged(progress));
        },
      );

      emit(UploadSuccess(result));
    } catch (e) {
      if (e is TruthLensException) {
        emit(UploadFailure(e));
      } else {
        emit(UploadFailure(UnknownException(e.toString())));
      }
    }
  }

  void _onProgressChanged(
    UploadProgressChanged event,
    Emitter<UploadState> emit,
  ) {
    emit(UploadInProgress(event.progress));
  }

  void _onCancelled(UploadCancelled event, Emitter<UploadState> emit) {
    // For now, simply reset to initial. Cancel token support can be added later.
    emit(UploadInitial());
  }
}
