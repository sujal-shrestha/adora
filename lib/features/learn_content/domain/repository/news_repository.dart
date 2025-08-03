import '../entity/article_entity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getNews(String query);
}
