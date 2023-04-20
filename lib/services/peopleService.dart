import 'package:cinemahub/models/peopleModel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../utils/http_service.dart';

class PeopleService{
  final GetIt getIt = GetIt.instance;
  late HTTPService _httpService;

  PeopleService(){
    _httpService = getIt.get<HTTPService>();
  }

  Future<List<PeopleModel>?> getPeople({required int movieId,required String department}) async {
    Response? peopleResponse = await _httpService.get('/movie/$movieId/credits',);
    if (peopleResponse!.statusCode == 200) {
      var data = peopleResponse.data;
      List<PeopleModel> peopleList = data[department].map<PeopleModel>((peopleData) {
        return PeopleModel.fromJson(peopleData);
      }).toList();
      return peopleList;
    } else {
      throw Exception('Couldn\'t load people list.');
    }
  }

}