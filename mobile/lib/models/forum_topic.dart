class ForumTopic {
  final String id;
  final String category;
  final String badge;
  final String author;
  final String title;
  final String timeAgo;
  final int replies;
  final int likes;
  final bool isFeatured;

  const ForumTopic({
    required this.id,
    required this.category,
    required this.badge,
    required this.author,
    required this.title,
    required this.timeAgo,
    required this.replies,
    this.likes = 0,
    this.isFeatured = false,
  });
}
