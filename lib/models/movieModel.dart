import 'package:get_it/get_it.dart';
import 'config.dart';

class MovieModel {
  final String title;
  final int id;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final bool isAdult;
  final String originalTitle;
  final String originalLanguage;
  final String releaseDate;
  final List genreId;

  MovieModel({
    required this.id,
    this.posterPath,
    required this.title,
    required this.overview,
    required this.isAdult,
    required this.originalLanguage,
    required this.releaseDate,
    this.backdropPath,
    required this.genreId,
    required this.originalTitle,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      isAdult: json['adult'],
      originalLanguage: json['original_language'],
      releaseDate: json['release_date'],
      originalTitle: json['original_title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      genreId: json['genre_ids'],
    );
  }

  String posterUrl(){
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.baseImageApiUrl}w500$posterPath';
  }

  String backdropUrl(){
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.baseImageApiUrl}w1280$backdropPath';
  }
}

class TVShow {
  final int id;
  final String name;
  String logoPath;

  TVShow({required this.id, required this.name, required this.logoPath});

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'],
      name: json['name'],
      logoPath: json['logo_path'] ?? '',
    );
  }
}