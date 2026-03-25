import 'package:flutter/material.dart';
import 'package:week4/models/news_model.dart';
import 'package:week4/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsArticles = []; // Placeholder for news articles
  bool isLoading = false;
  NewsService newsService = NewsService();

  Future<void> fetchNews() async {
    print('news provider called');
    isLoading = true;
    try {
      newsArticles=await newsService.fetchTopHeadlines().then((articles) => articles.map((article) => NewsModel.fromJson(article)).toList());
    }catch (e) {
      // Handle error
      print('Error fetching news: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}