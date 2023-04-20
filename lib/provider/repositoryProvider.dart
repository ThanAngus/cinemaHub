import 'dart:convert';
import 'package:cinemahub/models/genreModel.dart';
import 'package:cinemahub/models/mediaModel.dart';
import 'package:cinemahub/services/peopleService.dart';
import 'package:cinemahub/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../models/dataModel.dart';
import '../models/movieModel.dart';
import '../models/peopleModel.dart';
import '../services/movieService.dart';

final repositoryProvider = Provider((ref) {
  GetIt getIt = GetIt.instance;

  return RepositoryProvider(
    getIt: getIt,
  );
});

const String baseUrl = 'https://api.themoviedb.org/3';

class RepositoryProvider {
  final GetIt getIt;

  RepositoryProvider({
    required this.getIt,
  });

  final MovieService _movieService = GetIt.instance.get<MovieService>();
  final PeopleService _peopleService = GetIt.instance.get<PeopleService>();

  Future<List<MovieModel>?> getMovies(DataModel state) async {
    try {
      List<MovieModel>? movies = [];
      if (state.searchText!.isEmpty) {
        if (state.searchCategory == 'popular') {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: '/movie/popular',
          ));
        } else if (state.searchCategory == 'upcoming') {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: '/movie/upcoming',
          ));
        } else if (state.searchCategory == "trending") {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: 'trending/movie/week',
          ));
        } else if (state.searchCategory == "topRated") {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: 'movie/top_rated',
          ));
        } else if (state.searchCategory == "now_playing") {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: 'movie/now_playing',
          ));
        } else if (state.searchCategory == "") {
          movies = await (_movieService.getList(
            page: state.page,
            moviePath: 'discover/movie',
          ));
        }
      } else {
        movies = await (_movieService.searchMovies(state.searchText));
      }
      state = state.copyWith(
        movies: [...state.movies, ...movies!],
        page: state.page + 1,
      );
      return movies;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<MovieModel>?> getGenreMovies(
      String genre, String path, int page) async {
    try {
      return _movieService.getGenresMovie(
        genre: genre,
        path: path,
        page: page,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<PeopleModel>?> getPeopleList(
      int movieId, String department) async {
    try {
      return _peopleService.getPeople(
        movieId: movieId,
        department: department,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<ImagesModel>?> getImages(int id) async {
    try {
      return _movieService.getImagesMedias(
        movieId: id,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<VideoModel>?> getVideos(int id) async {
    try {
      return _movieService.getVideosMedias(movieId: id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<TVShow>> fetchPopularTVShows() async {
    final String url =
        '$baseUrl/tv/popular?api_key=${Constants.apiKey}&language=en-US&page=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      final List<TVShow> tvShows =
          data.map((json) => TVShow.fromJson(json)).toList();
      for (var tvShow in tvShows) {
        if (tvShow.logoPath.isNotEmpty) {
          final logoUrl = 'https://image.tmdb.org/t/p/w500${tvShow.logoPath}';
          final logoResponse = await http.get(Uri.parse(logoUrl));
          if (logoResponse.statusCode == 200 &&
              logoResponse.headers['content-type']?.startsWith('image') ==
                  true) {
            tvShow.logoPath = utf8.decode(logoResponse.bodyBytes);
          }
        }
      }
      return tvShows;
    } else {
      throw Exception('Failed to load popular TV shows');
    }
  }

  Future<List<Genre>?> fetchGenres(List ids) async {
    try {
      return await _movieService.getGenreName(ids);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<MovieModel>?> fetchSimilarMovies(int id) async {
    try {
      return _movieService.getSimilarMovies(
        id: id,
        page: 1,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<List<MovieModel>?> searchMovies(String? searchTerm,
      {int? page}) async {
    try {
      return await _movieService.searchMovies(
        searchTerm,
        page: page,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
