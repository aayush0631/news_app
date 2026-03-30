import 'package:flutter/material.dart';
import 'package:week6/core/models/news_model.dart';
import 'package:week6/core/utils/results.dart';
import 'package:week6/domain/repositories/news_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsArticles = [];
  bool isLoading = false;
  String? errorMessage;
  String query = '';

  final NewsRepository repository = getIt<NewsRepository>();

  Future<void> fetchNews({String? query}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await repository.getNews(query: query);

    switch (result) {
      case Success(:final data):
        newsArticles = data;

      case Failure(:final message):
        errorMessage = message;
        newsArticles = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void updateQuery(String newQuery) {
    query = newQuery;
    fetchNews(query: query);
  }

  void toggleBookmark(NewsModel article) {
    article.toggleBookmark();
    notifyListeners();
  }
}