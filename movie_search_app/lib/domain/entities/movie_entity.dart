class MovieEntity {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final String? overview;
  final double? voteAverage;

  MovieEntity({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    this.overview,
    this.voteAverage,
  });
}