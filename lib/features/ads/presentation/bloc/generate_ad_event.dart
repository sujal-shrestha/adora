part of 'generate_ad_bloc.dart';

abstract class GenerateAdEvent {}

/// Trigger ad generation with [prompt].
class GenerateAdRequested extends GenerateAdEvent {
  final String prompt;
  GenerateAdRequested(this.prompt);
}
