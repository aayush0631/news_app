class NewsModel {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String url;
  bool isBookmarked = false; // New field to track bookmark status

  NewsModel({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
    );
  }

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
  }
}