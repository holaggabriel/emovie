import 'package:flutter_test/flutter_test.dart';
import 'package:emovie/models/movie_model.dart';
import 'package:emovie/models/filter_model.dart';
import 'package:emovie/utils/movie_filter.dart';

void main() {
  group('Filtro local de películas', () {
    final movies = [
      MovieModel(
        id: 1,
        title: 'Película 1',
        originalTitle: 'Película 1',
        overview: 'Una película de prueba',
        posterPath: '',
        backdropPath: '',
        releaseDate: '2025-01-01',
        voteAverage: 8.0,
        voteCount: 100,
        genreIds: [28, 12],
        originalLanguage: 'es',
      ),
      MovieModel(
        id: 2,
        title: 'Película 2',
        originalTitle: 'Película 2',
        overview: 'Otra película',
        posterPath: '',
        backdropPath: '',
        releaseDate: '2024-05-01',
        voteAverage: 7.0,
        voteCount: 80,
        genreIds: [18],
        originalLanguage: 'en',
      ),
      MovieModel(
        id: 3,
        title: 'Película 3',
        originalTitle: 'Película 3',
        overview: 'Tercera película',
        posterPath: '',
        backdropPath: '',
        releaseDate: '2024-07-01',
        voteAverage: 9.0,
        voteCount: 200,
        genreIds: [35],
        originalLanguage: 'es',
      ),
    ];

    test('Filtra correctamente por idioma', () {
      final filter = FilterModel(
        name: 'Español',
        type: FilterType.language,
        filterValue: 'es',
      );

      final filtered = filterMovies(movies, filter);

      expect(filtered.length, 2);
      expect(filtered.map((m) => m.title), containsAll(['Película 1', 'Película 3']));
    });

    test('Filtra correctamente por año de lanzamiento', () {
      final filter = FilterModel(
        name: '2024',
        type: FilterType.releaseYear,
        filterValue: '2024',
      );

      final filtered = filterMovies(movies, filter);

      expect(filtered.length, 2);
      expect(filtered.map((m) => m.title), containsAll(['Película 2', 'Película 3']));
    });

    test('Limita el resultado a 6 películas', () {
      final filter = FilterModel(
        name: 'Español',
        type: FilterType.language,
        filterValue: 'es',
      );

      final repeatedMovies = List.generate(10, (_) => movies.first);
      final filtered = filterMovies(repeatedMovies, filter);

      expect(filtered.length, lessThanOrEqualTo(6));
    });

    test('Retorna lista vacía si no hay filtro', () {
      final filtered = filterMovies(movies, null);
      expect(filtered, isEmpty);
    });
  });
}
