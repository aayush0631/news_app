import 'package:dio/dio.dart';
import 'package:week6/data/news_resources/api_news_service.dart';

class NewsRepositoryImpl {
  final NewsService service;
  NewsRepositoryImpl(this.service);
  Future<Map<String,dynamic>> getUser() async {
    try{
      final data=await service.fetchNews();
      return{'success':true,'data':data};

    }on DioException catch(e){
      return{'success':false,'error':e.error.toString()};
    }
  }
}