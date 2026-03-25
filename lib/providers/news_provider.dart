import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:week6/models/news_model.dart';
import 'package:week6/services/api_news_service.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsArticles = []; // Stores fetched news
  bool isLoading = false;
  String query = '';

  // Get the NewsService instance from GetIt
  final NewsService newsService = getit<NewsService>();

  /// Fetch news with optional query
  Future<void> fetchNews({String? query}) async {
    isLoading = true;
    notifyListeners(); // Notify UI to show loading
    try {
      final articles = await newsService.fetchTopHeadlines(query: query);
      newsArticles = articles
          .map((article) => NewsModel.fromJson(article))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print(e.error); // Print the error message from DioException
      } else {
        print('Unexpected error: $e');
      }
      newsArticles = []; // Clear list on error
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI to update
    }
  }

  /// Update the query and fetch news
  void updateQuery(String newQuery) {
    query = newQuery;
    fetchNews(query: query);
  }
}