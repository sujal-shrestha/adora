class ArticleEntity {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  ArticleEntity({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });
}
