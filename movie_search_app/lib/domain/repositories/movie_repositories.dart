

import 'package:movie_search_app/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1});
  Future<List<MovieEntity>> getPopularMovies({int page = 1});
}