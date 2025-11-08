part of 'upload_bloc.dart';

@immutable
sealed class UploadState {}

final class UploadInitial extends UploadState {}

final class UploadInProgress extends UploadState {
  final double progress; // 0.0 - 1.0
  UploadInProgress(this.progress);
}

final class UploadSuccess extends UploadState {
  final AnalysisResult result;
  UploadSuccess(this.result);
}

final class UploadFailure extends UploadState {
  final TruthLensException exception;
  UploadFailure(this.exception);
}
