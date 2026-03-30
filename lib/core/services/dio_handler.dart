import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../data/news_resources/api_news_service.dart';

final getIt = GetIt.instance;

class DioHandler {
  final Dio dio;

  DioHandler()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          String errorDescription = '';
          if (e.type == DioExceptionType.connectionTimeout) {
            errorDescription = 'Connection timeout with API server';
          } else if (e.type == DioExceptionType.receiveTimeout) {
            errorDescription = 'Receive timeout in connection with API server';
          } else if (e.type == DioExceptionType.badResponse) {
            errorDescription = 'Received invalid status code: ${e.response?.statusCode}';
          } else if (e.type == DioExceptionType.connectionError) {
            errorDescription = 'Connection error with API server: ${e.message}';
          }
          else {
            errorDescription = 'Unexpected error occurred: ${e.message}';
          }
          handler.reject(DioException(
            requestOptions: e.requestOptions,
            error: errorDescription,
            type: e.type,
          ));
        },
      ),
    );
  }

  // Setup registers the DioHandler itself
  static void setup() {
    if (!getIt.isRegistered<DioHandler>()) {
      getIt.registerLazySingleton<DioHandler>(() => DioHandler());
    }

    // Optionally, also register NewsService
    if (!getIt.isRegistered<NewsService>()) {
      getIt.registerLazySingleton<NewsService>(() => NewsService());
    }
  }

}