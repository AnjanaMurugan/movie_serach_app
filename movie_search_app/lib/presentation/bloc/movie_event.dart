import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object> get props => [];
}

class SearchMoviess extends MovieEvent {
  final String query;
  const SearchMoviess(this.query);
  @override
  List<Object> get props => [query];
}

class FetchPopularMovies extends MovieEvent {}

class LoadMorePopularMovies extends MovieEvent {}

class LoadMoreSearchMovies extends MovieEvent {}