import 'package:movie_search_app/domain/repositories/movie_repositories.dart';

import '../entities/movie_entity.dart';


class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<MovieEntity>> call(String query, {int page = 1}) async {
    return await repository.searchMovies(query, page: page);
  }
}