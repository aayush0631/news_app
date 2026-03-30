import 'package:dio/dio.dart';
import '../../core/services/api_constants.dart';
import 'package:week6/core/services/dio_handler.dart';

class NewsService {
  final Dio dio = getIt<DioHandler>().dio; // Get Dio instance from GetIt

  /// Fetch news articles from Everything endpoint
  /// If [query] is null or empty, default to 'news'
  Future<List<dynamic>> fetchNews({
    String? query,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'apiKey': ApiConstants.apiKey,
      'q': query != null && query.isNotEmpty ? query : 'news',
      'sortBy': 'publishedAt', // newest first
      'page': page,
      'pageSize': pageSize,
    };

    final response = await dio.get(
      ApiConstants
          .everythingEndpoint, // make sure this points to /v2/everything
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200 && response.data['status'] == 'ok') {
      return response.data['articles'] as List<dynamic>;
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
