import 'package:dio/dio.dart';
import 'package:week6/core/services/api_constants.dart';
import 'package:week6/core/services/dio_handler.dart';
import 'package:week6/core/utils/error_handler.dart';
import 'package:week6/core/utils/results.dart';

class NewsService {
  final Dio dio = getIt<DioHandler>().dio;

  Future<Result<List<dynamic>>> fetchNews({
    String? query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParameters = {
        'apiKey': ApiConstants.apiKey,
        'q': query != null && query.isNotEmpty ? query : 'news',
        'sortBy': 'publishedAt',
        'page': page,
        'pageSize': pageSize,
      };

      final response = await dio.get(
        ApiConstants.everythingEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'ok') {
        return Success(response.data['articles']);
      } else {
        return Failure('Failed to load news: ${response.statusCode}');
      }

    } on DioException catch (e) {
      return Failure(handleDioError(e));
    } catch (e) {
      return Failure('Something went wrong');
    }
  }
}