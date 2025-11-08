part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisState {}

final class AnalysisInitial extends AnalysisState {

}

final class AnalysisLoading extends AnalysisState {}

final class AnalysisSuccess extends AnalysisState {
  final String result; // Or a more complex AnalysisResult object
  AnalysisSuccess(this.result);
}

final class AnalysisFailure extends AnalysisState {
  final String error;
  AnalysisFailure(this.error);
}

final class AnalysisProgress extends AnalysisState {
  final double progress; // 0.0 - 1.0
  AnalysisProgress(this.progress);
}

