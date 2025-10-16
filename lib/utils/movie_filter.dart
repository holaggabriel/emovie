import '../models/movie_model.dart';
import '../models/filter_model.dart';

/// Filtra una lista de películas según el filtro seleccionado.
/// Limita los resultados a un máximo de [maxResults] elementos.
List<MovieModel> filterMovies(
  List<MovieModel> movies,
  FilterModel? filter, {
  int maxResults = 6,
}) {
  if (filter == null) return [];

  final filtered = movies.where((movie) {
    switch (filter.type) {
      case FilterType.language:
        return movie.originalLanguage == filter.filterValue;
      case FilterType.releaseYear:
        return movie.releaseDate.startsWith(filter.filterValue);
    }
  }).take(maxResults).toList();

  return filtered;
}
