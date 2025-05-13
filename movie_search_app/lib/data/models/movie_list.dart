class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final String? overview;
  final double? voteAverage;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    this.overview,
    this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }
}