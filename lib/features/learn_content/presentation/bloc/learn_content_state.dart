part of 'learn_content_bloc.dart';

abstract class LearnContentState {}

class LearnContentInitial extends LearnContentState {}

class LearnContentLoading extends LearnContentState {}

class LearnContentLoaded extends LearnContentState {
  final List<ArticleEntity> articles;
  LearnContentLoaded(this.articles);
}

class LearnContentError extends LearnContentState {
  final String message;
  LearnContentError(this.message);
}
