import '../../domain/entity/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel({
    required String title,
    required String description,
    required String url,
    required String imageUrl,
    required DateTime publishedAt,
  }) : super(
          title: title,
          description: description,
          url: url,
          imageUrl: imageUrl,
          publishedAt: publishedAt,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
