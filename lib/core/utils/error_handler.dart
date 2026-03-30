import 'package:dio/dio.dart';

String handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout';
    case DioExceptionType.receiveTimeout:
      return 'Receive timeout';
    case DioExceptionType.badResponse:
      return 'Invalid status: ${e.response?.statusCode}';
    case DioExceptionType.connectionError:
      return 'No internet connection';
    default:
      return e.message ?? 'Unexpected error';
  }
}