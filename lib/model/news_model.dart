class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }
}

class Podcast {
  final String title;
  final String category;
  final String imageUrl;

  Podcast({
    required this.title,
    required this.category,
    required this.imageUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}