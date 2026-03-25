import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'package:week6/services/dio_handler.dart';

class NewsService {
  final Dio dio = getIt<DioHandler>().dio; // Get Dio instance from GetIt

  Future<List<dynamic>> fetchTopHeadlines({String? query}) async {
    final queryParameters = <String, dynamic>{
      'apiKey': ApiConstants.apiKey,
    };

    if (query != null) {
      queryParameters['q'] = query;
    } else {
      queryParameters['country'] = 'us';
    }
    
      final response = await dio.get(
        ApiConstants.topHeadlinesEndpoint,
        queryParameters: queryParameters,
      );

    if (response.statusCode == 200&& response.data['status'] == 'ok') {
      return response.data['articles'] as List<dynamic>;
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}