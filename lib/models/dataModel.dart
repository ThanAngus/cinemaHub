
import 'package:cinemahub/models/movieModel.dart';

class DataModel {
  final List<MovieModel> movies;
  final int page;
  final String? searchCategory;
  final String? searchText;

  DataModel({
    required this.movies,
    required this.page,
    this.searchCategory,
    this.searchText,
  });

  DataModel.initial()
      : movies = [],
        page = 1,
        searchCategory = '',
        searchText = '';

  DataModel copyWith({required List<MovieModel> movies, required int page, String? searchCategory, String? searchText,}) {
    return DataModel(
      movies: movies,
      page: page,
      searchCategory: searchCategory,
      searchText: searchText,
    );
  }
}

List<String> genres = [
  'Action',
  'Adventure',
  'Animation',
  'Comedy',
  'Crime',
  'Documentary',
  'Drama',
  'Family',
  'Fantasy',
  'History',
  'Horror',
  'Music',
  'Mystery',
  'Romance',
  'Science Fiction',
  'TV Movie',
  'Thriller',
  'War',
  'Western'
];
