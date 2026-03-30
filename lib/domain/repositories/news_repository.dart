import 'package:week6/core/models/news_model.dart';
import 'package:week6/core/utils/results.dart';

abstract class NewsRepository {
  Future<Result<List<NewsModel>>> getNews({String? query});
}