import '../../data/services/api_service.dart';
import '../../domain/entities/movie_entity.dart';

import 'movie_repositories.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbApi tmdbApi;

  MovieRepositoryImpl(this.tmdbApi);

  @override
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1}) async {
    try {
      final movies = await tmdbApi.searchMovies(query,);
      return movies
          .map((movie) => MovieEntity(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseDate: movie.releaseDate,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  @override
  Future<List<MovieEntity>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await tmdbApi.getPopularMovies(page: page);
      return movies
          .map((movie) => MovieEntity(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseDate: movie.releaseDate,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch popular movies: $e');
    }
  }
}