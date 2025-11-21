part of 'upload_bloc.dart';

@immutable
sealed class UploadEvent {}

final class UploadImageRequested extends UploadEvent {
  final File file;
  UploadImageRequested(this.file);
}

final class UploadVideoRequested extends UploadEvent {
  final File file;
  UploadVideoRequested(this.file);
}

final class UploadProgressChanged extends UploadEvent {
  final double progress; // 0.0 - 1.0
  UploadProgressChanged(this.progress);
}

final class UploadCancelled extends UploadEvent {}

final class UploadAnalyzingStarted extends UploadEvent {}
