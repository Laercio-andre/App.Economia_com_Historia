enum ArticleType { texto, video, podcast }

class Article {
  final String id;
  final String category;
  final String title;
  final String description;
  final String imageUrl;
  final String readTime;
  final ArticleType type;
  final bool hasImage;
  final String body;

  const Article({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.readTime,
    required this.type,
    required this.body,
    this.hasImage = true,
  });
}
