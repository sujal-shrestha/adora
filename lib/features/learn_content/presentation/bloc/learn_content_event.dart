part of 'learn_content_bloc.dart';

abstract class LearnContentEvent {}

class FetchNewsRequested extends LearnContentEvent {
  final String query;
  FetchNewsRequested(this.query);
}
