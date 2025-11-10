part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisEvent {
  const AnalysisEvent();
}

final class AnalyzeImage extends AnalysisEvent {
  final String imagePath;
  const AnalyzeImage(this.imagePath);
}

final class AnalyzeVideo extends AnalysisEvent {
  final String videoPath;
  const AnalyzeVideo(this.videoPath);
}

final class AnalysisProgressUpdate extends AnalysisEvent {
  final double progress;
  const AnalysisProgressUpdate(this.progress);
}

final class AnalysisCompleted extends AnalysisEvent {
  final String result;
  const AnalysisCompleted(this.result);
}

final class AnalysisError extends AnalysisEvent {
  final String error;
  const AnalysisError(this.error);
}
