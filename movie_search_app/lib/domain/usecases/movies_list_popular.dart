import '../entities/movie_entity.dart';
import '../repositories/movie_repositories.dart';


class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<List<MovieEntity>> call({int page = 1}) async {
    return await repository.getPopularMovies(page: page);
  }
}