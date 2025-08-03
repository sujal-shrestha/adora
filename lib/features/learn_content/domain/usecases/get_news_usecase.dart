import '../entity/article_entity.dart';
import '../repository/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository repository;
  GetNewsUseCase(this.repository);

  Future<List<ArticleEntity>> call(String query) {
    return repository.getNews(query);
  }
}
