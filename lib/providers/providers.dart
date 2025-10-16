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

/// Servicios y estado básico
final movieServiceProvider = Provider<MovieService>((ref) => MovieService());
final connectivityServiceProvider = Provider<ConnectivityService>((ref) => ConnectivityService());
final isOfflineProvider = StateProvider<bool>((ref) => false);

/// Filtros
final availableFiltersProvider = Provider<List<FilterModel>>((ref) => mockFilters);
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

/// --- CLASE BASE PARA COMPARTIR LÓGICA ---

abstract class BaseMovieNotifier<T> extends AsyncNotifier<List<T>> {
  late MovieService _service;
  
  @override
  Future<List<T>> build() async {
    _service = ref.read(movieServiceProvider);
    return await loadData();
  }

  // Métodos abstractos que deben implementar las clases hijas
  Future<List<T>> fetchFromApi();
  String get boxName;

  Future<List<T>> loadData({bool forceRefresh = false}) async {
    final box = Hive.box<T>(boxName);
    
    // Verificar conexión
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;

    // Con conexión: intentar API primero
    if (isConnected) {
      try {
        final data = await fetchFromApi();
        await box.clear();
        await box.addAll(data);
        return data;
      } catch (e) {
        // Fallback a cache si API falla
        if (box.isNotEmpty) return box.values.toList();
        rethrow;
      }
    }

    // Sin conexión: usar cache
    if (box.isNotEmpty) {
      return box.values.toList();
    } else {
      throw Exception('Sin conexión y sin datos locales');
    }
  }

  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => loadData(forceRefresh: true));
  }
}

/// --- IMPLEMENTACIONES ESPECÍFICAS ---

class MovieGenresNotifier extends BaseMovieNotifier<MovieGenreModel> {
  @override
  String get boxName => 'movieGenres';

  @override
  Future<List<MovieGenreModel>> fetchFromApi() {
    return _service.getMovieGenres();
  }
}

class UpcomingMoviesNotifier extends BaseMovieNotifier<MovieModel> {
  @override
  String get boxName => 'upcomingMovies';

  @override
  Future<List<MovieModel>> fetchFromApi() {
    return _service.getUpcomingMovies();
  }
}

class TrendingMoviesNotifier extends BaseMovieNotifier<MovieModel> {
  @override
  String get boxName => 'trendingMovies';

  @override
  Future<List<MovieModel>> fetchFromApi() {
    return _service.getTrendingMovies();
  }
}

/// Providers
final movieGenresProvider = AsyncNotifierProvider<MovieGenresNotifier, List<MovieGenreModel>>(
  () => MovieGenresNotifier(),
);

final upcomingMoviesProvider = AsyncNotifierProvider<UpcomingMoviesNotifier, List<MovieModel>>(
  () => UpcomingMoviesNotifier(),
);

final trendingMoviesProvider = AsyncNotifierProvider<TrendingMoviesNotifier, List<MovieModel>>(
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
  return () async {
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.isConnectedToInternet();
    ref.read(isOfflineProvider.notifier).state = !isConnected;
    
    if (!isConnected) {
      printInDebugMode('⚠️ Sin conexión, no se puede refrescar');
      return;
    }
    
    await Future.wait([
      ref.read(movieGenresProvider.notifier).refreshData(),
      ref.read(upcomingMoviesProvider.notifier).refreshData(),
      ref.read(trendingMoviesProvider.notifier).refreshData(),
    ]);
  };
});