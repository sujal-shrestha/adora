import '../../domain/entity/article_entity.dart';
import '../../domain/repository/news_repository.dart';
import '../datasource/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;

  NewsRepositoryImpl(this.remote);

  @override
  Future<List<ArticleEntity>> getNews(String query) {
    return remote.fetchNews(query);
  }
}
