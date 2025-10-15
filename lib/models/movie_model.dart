import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String originalTitle;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String posterPath;

  @HiveField(5)
  final String backdropPath;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  final double voteAverage;

  @HiveField(8)
  final int voteCount;

  @HiveField(9)
  final List<int> genreIds;

  @HiveField(10)
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

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'https://image.tmdb.org/t/p/w500';

    String poster = json['poster_path'] ?? '';
    String backdrop = json['backdrop_path'] ?? '';

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
