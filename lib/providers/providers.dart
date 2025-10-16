import 'package:emovie/utils/debug_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/movie_model.dart';
import '../models/movie_genre_model.dart';
import '../models/filter_model.dart';
import '../services/tmdb_service.dart';
import '../services/connectivity_service.dart';
import '../data/mock_data.dart';
import '../utils/movie_filter.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Servicio
final movieServiceProvider = Provider<MovieService>((ref) => MovieService());

/// Estado offline
final isOfflineProvider = StateProvider<bool>((ref) => false);

/// Filtros disponibles
final availableFiltersProvider = Provider<List<FilterModel>>((ref) {
  return mockFilters;
});

/// FILTRO SELECCIONADO
final selectedFilterProvider = StateProvider<FilterModel>((ref) {
  final filters = ref.read(availableFiltersProvider);
  return filters.isNotEmpty ? filters.first : FilterModel.empty();
});

/// Estado de carga combinado
final loadingStateProvider = Provider<Map<String, bool>>((ref) {
  final upcoming = ref.watch(upcomingMoviesProvider).isLoading;
  final trending = ref.watch(trendingMoviesProvider).isLoading;
  final genres = ref.watch(movieGenresProvider).isLoading;

  return {'upcoming': upcoming, 'trending': trending, 'genres': genres};
});

/// GÉNEROS
class MovieGenresNotifier extends AsyncNotifier<List<MovieGenreModel>> {
  late MovieService _service;

  @override
  Future<List<MovieGenreModel>> build() async {
    _service = ref.read(movieServiceProvider);
    return await loadGenres();
  }

  Future<List<MovieGenreModel>> loadGenres({bool forceRefresh = false}) async {
    final box = Hive.box<MovieGenreModel>('movieGenres');

    // 1. ✅ PRIMERO verificar conexión y actualizar estado
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;

    // 2. ✅ PRIORIDAD: Si hay conexión, intentar API primero
    if (isConnected) {
      try {
        final genres = await _service.getMovieGenres();
        await box.clear();
        await box.addAll(genres);
        return genres;
      } catch (e) {
        // ✅ Si API falla, usar cache como fallback
        if (box.isNotEmpty) return box.values.toList();
        rethrow;
      }
    }

    // 3. ✅ SOLO si no hay conexión, usar cache
    if (box.isNotEmpty) {
      return box.values.toList();
    } else {
      throw Exception('Sin conexión y sin datos locales');
    }
  }

  // Método para forzar refresh
  Future<void> refreshGenres() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => loadGenres(forceRefresh: true));
  }
}

final movieGenresProvider =
    AsyncNotifierProvider<MovieGenresNotifier, List<MovieGenreModel>>(
      () => MovieGenresNotifier(),
    );

/// PRÓXIMOS ESTRENOS
class UpcomingMoviesNotifier extends AsyncNotifier<List<MovieModel>> {
  late MovieService _service;

  @override
  Future<List<MovieModel>> build() async {
    _service = ref.read(movieServiceProvider);
    return await loadMovies();
  }

  Future<List<MovieModel>> loadMovies({bool forceRefresh = false}) async {
    final box = Hive.box<MovieModel>('upcomingMovies');

    // 1. ✅ PRIMERO verificar conexión y actualizar estado
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;

    // 2. ✅ PRIORIDAD: Si hay conexión, intentar API primero
    if (isConnected) {
      try {
        final movies = await _service.getUpcomingMovies();
        await box.clear();
        await box.addAll(movies);
        return movies;
      } catch (e) {
        // ✅ Si API falla, usar cache como fallback
        if (box.isNotEmpty) return box.values.toList();
        rethrow;
      }
    }

    // 3. ✅ SOLO si no hay conexión, usar cache
    if (box.isNotEmpty) {
      return box.values.toList();
    } else {
      throw Exception('Sin conexión y sin datos locales');
    }
  }

  // Método para forzar refresh
  Future<void> refreshMovies() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => loadMovies(forceRefresh: true));
  }
}

final upcomingMoviesProvider =
    AsyncNotifierProvider<UpcomingMoviesNotifier, List<MovieModel>>(
      () => UpcomingMoviesNotifier(),
    );

/// TRENDING
class TrendingMoviesNotifier extends AsyncNotifier<List<MovieModel>> {
  late MovieService _service;

  @override
  Future<List<MovieModel>> build() async {
    _service = ref.read(movieServiceProvider);
    return await loadMovies();
  }

  Future<List<MovieModel>> loadMovies({bool forceRefresh = false}) async {
    final box = Hive.box<MovieModel>('trendingMovies');

    // 1. ✅ PRIMERO verificar conexión y actualizar estado
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;

    // 2. ✅ PRIORIDAD: Si hay conexión, intentar API primero
    if (isConnected) {
      try {
        final movies = await _service.getTrendingMovies();
        await box.clear();
        await box.addAll(movies);
        return movies;
      } catch (e) {
        // ✅ Si API falla, usar cache como fallback
        if (box.isNotEmpty) return box.values.toList();
        rethrow;
      }
    }

    // 3. ✅ SOLO si no hay conexión, usar cache
    if (box.isNotEmpty) {
      return box.values.toList();
    } else {
      throw Exception('Sin conexión y sin datos locales');
    }
  }

  // Método para forzar refresh
  Future<void> refreshMovies() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => loadMovies(forceRefresh: true));
  }
}

final trendingMoviesProvider =
    AsyncNotifierProvider<TrendingMoviesNotifier, List<MovieModel>>(
      () => TrendingMoviesNotifier(),
    );

/// RECOMENDADAS (derivadas de trending + filtro)
final recommendedMoviesProvider = Provider<List<MovieModel>>((ref) {
  final trending = ref
      .watch(trendingMoviesProvider)
      .maybeWhen(data: (data) => data, orElse: () => <MovieModel>[]);

  final selectedFilter = ref.watch(selectedFilterProvider);

  return filterMovies(trending, selectedFilter);
});

/// Provider para refrescar todos los datos
final refreshAllProvider = Provider<Future<void> Function()>((ref) {
  Future<void> refreshAll() async {
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;
    // Si no hay conexión, no hacer nada
    if (!isConnected) {
      printInDebugMode('⚠️ Sin conexión, no se puede refrescar');
      return;
    }
    ref.read(movieGenresProvider.notifier).refreshGenres();
    ref.read(upcomingMoviesProvider.notifier).refreshMovies();
    ref.read(trendingMoviesProvider.notifier).refreshMovies();
  }

  return refreshAll; // <- Esto es clave
});
