import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/config.dart';

class HTTPService{
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String baseUrl;
  late String apiKey;

  HTTPService(){
    AppConfig config = getIt.get<AppConfig>();
    baseUrl = config.baseApUrl;
    apiKey = config.apiKey;
  }

  Future<Response?> get(String path, {Map<String, dynamic>? customQuery}) async{
    String url = '$baseUrl$path';
    Map<String, dynamic> query = {
      'api_key' : apiKey,
      'language' : 'en-US',
    };
    if(customQuery != null){
      query.addAll(customQuery);
    }
    return await dio.get(url, queryParameters: query);
  }
}