class MovieModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final String originalLanguage;

  const MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originalLanguage,
  });

  // Factory constructor para crear MovieModel desde JSON
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'https://image.tmdb.org/t/p/w500';

    String poster = json['poster_path'] ?? '';
    String backdrop = json['backdrop_path'] ?? '';

    // Solo agregamos baseUrl si hay path
    poster = poster.isNotEmpty ? '$baseUrl$poster' : '';
    backdrop = backdrop.isNotEmpty ? '$baseUrl$backdrop' : '';

    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: poster,
      backdropPath: backdrop,
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'] ?? '',
    );
  }
}
