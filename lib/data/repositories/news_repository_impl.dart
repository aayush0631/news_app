import 'package:week6/core/models/news_model.dart';
import 'package:week6/core/utils/results.dart';
import 'package:week6/data/news_resources/api_news_service.dart';
import 'package:week6/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsService service;

  NewsRepositoryImpl(this.service);

  @override
  Future<Result<List<NewsModel>>> getNews({String? query}) async {
    final result = await service.fetchNews(query: query);

    switch (result) {
      case Success(:final data):
        final news = data
            .map((article) => NewsModel.fromJson(article))
            .toList();
        return Success(news);

      case Failure(:final message):
        return Failure(message);
    }
  }
}