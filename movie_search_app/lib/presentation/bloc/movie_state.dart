part of 'movie_bloc.dart';

@immutable
abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;
  final bool hasMore;
  final bool isLoadingMore;

  const MovieLoaded({
    required this.movies,
    required this.hasMore,
    required this.isLoadingMore,
  });

  MovieLoaded copyWith({
    List<MovieEntity>? movies,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, hasMore, isLoadingMore];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}