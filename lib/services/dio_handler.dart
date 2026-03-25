import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_news_service.dart';

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