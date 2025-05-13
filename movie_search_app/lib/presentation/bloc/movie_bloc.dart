import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:movie_search_app/domain/usecases/serach_movies.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/movies_list_popular.dart';
import 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final SearchMovies searchMovies;
  final GetPopularMovies getPopularMovies;
  int _popularPage = 1;
  int _searchPage = 1;
  String? currentQuery;
  bool _isFetching = false;
  static const int _pageSize = 10;

  MovieBloc(this.searchMovies, this.getPopularMovies) : super(MovieInitial()) {
    on<FetchPopularMovies>((event, emit) async {
      if (_isFetching) return;
      _isFetching = true;
      emit(MovieLoading());
      try {
        final movies = await getPopularMovies(page: _popularPage);
        final limitedMovies = movies.take(_pageSize).toList();
        emit(MovieLoaded(
          movies: limitedMovies,
          hasMore: movies.length > _pageSize,
          isLoadingMore: false,
        ));
        _popularPage++;
      } catch (e) {
        emit(MovieError('Failed to fetch popular movies: $e'));
      } finally {
        _isFetching = false;
      }
    });

    on<LoadMorePopularMovies>((event, emit) async {
      if (_isFetching || state is! MovieLoaded || !(state as MovieLoaded).hasMore) return;
      _isFetching = true;
      final currentState = state as MovieLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final movies = await getPopularMovies(page: _popularPage);
        final limitedMovies = movies.take(_pageSize).toList();
        emit(MovieLoaded(
          movies: [...currentState.movies, ...limitedMovies],
          hasMore: movies.length > _pageSize,
          isLoadingMore: false,
        ));
        _popularPage++;
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      } finally {
        _isFetching = false;
      }
    });

    on<SearchMoviess>((event, emit) async {
      if (_isFetching) return;
      _isFetching = true;
      currentQuery = event.query;
      _searchPage = 1;
      if (event.query.isEmpty) {
        _isFetching = false;
        add(FetchPopularMovies());
        return;
      }
      emit(MovieLoading());
      try {
        final movies = await searchMovies(event.query, page: _searchPage);
        final limitedMovies = movies.take(_pageSize).toList();
        emit(MovieLoaded(
          movies: limitedMovies,
          hasMore: movies.length > _pageSize,
          isLoadingMore: false,
        ));
        _searchPage++;
      } catch (e) {
        emit(MovieError('Failed to fetch movies: $e'));
      } finally {
        _isFetching = false;
      }
    });

    on<LoadMoreSearchMovies>((event, emit) async {
      if (_isFetching || state is! MovieLoaded || !(state as MovieLoaded).hasMore || currentQuery == null) return;
      _isFetching = true;
      final currentState = state as MovieLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final movies = await searchMovies(currentQuery!, page: _searchPage);
        final limitedMovies = movies.take(_pageSize).toList();
        emit(MovieLoaded(
          movies: [...currentState.movies, ...limitedMovies],
          hasMore: movies.length > _pageSize,
          isLoadingMore: false,
        ));
        _searchPage++;
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      } finally {
        _isFetching = false;
      }
    });

    add(FetchPopularMovies());
  }
}