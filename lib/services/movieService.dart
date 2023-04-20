import 'package:cinemahub/models/genreModel.dart';
import 'package:cinemahub/models/mediaModel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/movieModel.dart';
import '../utils/http_service.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late HTTPService _httpService;

  MovieService() {
    _httpService = getIt.get<HTTPService>();
  }

  Future<List<MovieModel>?> getList(
      {int? page, required String moviePath}) async {
    Response? movieResponse = await _httpService.get(moviePath, customQuery: {
      'page': page,
      "original_language": "en",
    });
    if (movieResponse!.statusCode == 200) {
      var movieData = movieResponse.data;
      List<MovieModel> moviesList = movieData['results'].map<MovieModel>((movieData) {
        return MovieModel.fromJson(movieData);
      }).toList();
      return moviesList;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }
  
  Future<List<ImagesModel>> getImagesMedias({required int movieId}) async{
    Response? mediaResponse = await _httpService.get('/movie/$movieId/images',customQuery: {
      'include_image_language' : true,
    });
    if(mediaResponse!.statusCode == 200){
      var mediaData = mediaResponse.data;
      List<ImagesModel> imageList = mediaData['results'].map<ImagesModel>((imageData){
        return ImagesModel.fromJson(imageData);
      });
      return imageList;
    }else {
      throw Exception('Couldn\'t load genre movies.');
    }
  }

  Future<List<VideoModel>> getVideosMedias({required int movieId}) async{
    Response? videoResponse = await _httpService.get('/movie/$movieId/videos',customQuery: {
      'include_video_language' : true,
      'published_at' : 'Youtube',
    });
    if(videoResponse!.statusCode == 200){
      var videoData = videoResponse.data;
      List<VideoModel> videoList = videoData['results'].map<VideoModel>((videoData){
        return VideoModel.fromJson(videoData);
      }).toList();
      return videoList;
    }else {
      throw Exception('Couldn\'t load genre movies.');
    }
  }

  Future<List<MovieModel>?> getGenresMovie(
      {required String genre, required String path, required int page}) async {
    Genre? genreModel = await getGenreID(genre);
    Response? movieResponse = await _httpService.get(path, customQuery: {
      'page': page,
      'with_genres': "${genreModel!.id}",
    });
    if (movieResponse!.statusCode == 200) {
      var movieData = movieResponse.data;
      List<MovieModel> moviesList = movieData['results'].map<MovieModel>((movieData) {
            return MovieModel.fromJson(movieData);
      }).toList();
      return moviesList;
    } else {
      throw Exception('Couldn\'t load genre movies.');
    }
  }

  Future<Genre?> getGenreID(String genreName) async {
    Response? response = await _httpService.get(
      '/genre/movie/list',
    );
    Genre? genreModel;
    if (response!.statusCode == 200) {
      var data = response.data;
      var genreData = data['genres'];
      for (final genre in genreData) {
        final genreTitle = genre['name'];
        final genreId = genre['id'];
        if (genreTitle == genreName) {
          genreModel = Genre(
            id: genreId,
            name: genreTitle,
          );
        }
      }
      return genreModel;
    } else {
      throw Exception('Couldn\'t load genres.');
    }
  }

  Future<List<Genre>?> getGenreName(List genreID) async {
    Response? response = await _httpService.get(
      '/genre/movie/list',
    );
    List<Genre>? genreModel = [];
    if (response!.statusCode == 200) {
      var data = response.data;
      var genreData = data['genres'];
      for (final genre in genreData) {
        final genreTitle = genre['name'];
        final genreId = genre['id'];
        for(final id in genreID){
          if (genreId == id) {
            genreModel.add(
              Genre(
                id: genreId,
                name: genreTitle,
              ),
            );
          }
        }
      }
      return genreModel;
    } else {
      throw Exception('Couldn\'t load genres.');
    }
  }

  Future<List<MovieModel>?> getSimilarMovies(
      {int? page, required int id}) async {
    Response? response = await _httpService.get('/movie/$id/similar', customQuery: {
      'page': page,
    });
    if (response!.statusCode == 200) {
      var data = response.data;
      List<MovieModel> movies = data['results'].map<MovieModel>((movieData){
        return MovieModel.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load similar movies.');
    }
  }

  Future<List<MovieModel>?> searchMovies(String? searchTerm, {int? page}) async{
    Response? response = await _httpService.get('/search/movie', customQuery: {
      'query': searchTerm,
      'page': page,
      'include_image_language' : true,
    });
    print(response);
    if (response!.statusCode == 200) {
      var data = response.data;
      List<MovieModel> movies = data['results'].map<MovieModel>((movieData){
        return MovieModel.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t perform movies search.');
    }
  }
}
