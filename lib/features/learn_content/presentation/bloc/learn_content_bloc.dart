import 'package:adora_mobile_app/features/learn_content/domain/entity/article_entity.dart';
import 'package:adora_mobile_app/features/learn_content/domain/usecases/get_news_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'learn_content_event.dart';
part 'learn_content_state.dart';

class LearnContentBloc extends Bloc<LearnContentEvent, LearnContentState> {
  final GetNewsUseCase getNews;
  LearnContentBloc(this.getNews) : super(LearnContentInitial()) {
    on<FetchNewsRequested>(_onFetchNews);
  }

  Future<void> _onFetchNews(
    FetchNewsRequested event,
    Emitter<LearnContentState> emit,
  ) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(LearnContentError('Please enter a search term'));
      return;
    }
    emit(LearnContentLoading());
    try {
      final list = await getNews(q);
      emit(LearnContentLoaded(list));
    } catch (e) {
      emit(LearnContentError(e.toString()));
    }
  }
}
