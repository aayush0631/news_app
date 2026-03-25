import 'package:dio/dio.dart';
import 'api_constants.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
class NewsService {
  Future<List<dynamic>> fetchTopHeadlines() async {
    try {
      final response = await dio.get(
        ApiConstants.topHeadlinesEndpoint,
        queryParameters: {
          'q': 'technology',
          'apiKey': ApiConstants.apiKey,
        },
      );
      if (response.statusCode == 200) {
        return response.data['articles'] as List<dynamic>;
      } else {
        throw Exception('error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}
