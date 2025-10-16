import 'package:emovie/models/filter_model.dart';
import 'package:emovie/models/movie_genre_model.dart';
import 'package:emovie/models/movie_model.dart';
import 'package:emovie/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emovie/utils/debug_print.dart';
import 'package:emovie/screens/widgets/shimmer_text.dart';
import 'package:emovie/screens/widgets/filter_selector.dart';
import 'package:emovie/screens/widgets/movie_list_horizontal.dart';
import 'package:emovie/screens/widgets/movie_grid_limited.dart';
import 'package:emovie/screens/widgets/section_title.dart';
import 'package:emovie/screens/movie_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final filters = ref.watch(availableFiltersProvider);
    final loadingStates = ref.watch(loadingStateProvider);

    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final trendingMovies = ref.watch(trendingMoviesProvider);
    final recommendedMovies = ref.watch(recommendedMoviesProvider);
    final movieGenres = ref.watch(movieGenresProvider);
    final refreshAll = ref.read(refreshAllProvider);

    Future<void> onRefresh() async {
      printInDebugMode('🔄 Usuario intentó recargar datos');
      await Future.delayed(const Duration(milliseconds: 300));
      printInDebugMode('✅ Ejecutando refresh...');
      refreshAll();
    }

    void onFilterSelected(FilterModel filter) {
      ref.read(selectedFilterProvider.notifier).state = filter;
    }

    void navigateToDetails(MovieModel movie) {
      movieGenres.when(
        data: (genres) {
          _navigateToMovieDetails(context, movie, genres);
        },
        loading: () {
          _navigateToMovieDetails(context, movie, []);
        },
        error: (error, stack) {
          _navigateToMovieDetails(context, movie, []);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eMovies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black45,
      body: Column(
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              color: Colors.red,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(5),
              child: const Text(
                'Sin conexión a internet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              color: Colors.white,
              backgroundColor: Colors.black,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SectionTitle('Próximos estrenos'),
                  _UpcomingMoviesSection(
                    upcomingMovies: upcomingMovies,
                    isLoading: loadingStates['upcoming']!,
                    onMovieTap: navigateToDetails,
                  ),
                  const SizedBox(height: 16),
                  const SectionTitle('Tendencias'),
                  _TrendingMoviesSection(
                    trendingMovies: trendingMovies,
                    isLoading: loadingStates['trending']!,
                    onMovieTap: navigateToDetails,
                  ),
                  const SizedBox(height: 16),
                  const SectionTitle('Recomendados para ti'),
                  FilterSelector(
                    filters: filters,
                    onFilterSelected: onFilterSelected,
                    selectedFilter: selectedFilter,
                  ),
                  const SizedBox(height: 16),
                  _RecommendedMoviesSection(
                    movies: recommendedMovies,
                    isLoading: loadingStates['trending']!,
                    onMovieTap: navigateToDetails,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMovieDetails(
    BuildContext context,
    MovieModel movie,
    List<MovieGenreModel> genres,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MovieDetailsScreen(movie: movie, allGenres: genres),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(opacity: curvedAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

/// Widget independiente para la sección de próximos estrenos
class _UpcomingMoviesSection extends StatelessWidget {
  final AsyncValue<List<MovieModel>> upcomingMovies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const _UpcomingMoviesSection({
    required this.upcomingMovies,
    required this.isLoading,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return upcomingMovies.when(
      loading: () => const ShimmerText(text: "Cargando películas próximas..."),
      error: (error, stack) {
        printInDebugMode('❌ Error en próximos estrenos: $error');
        return const _ErrorMessage('Error al cargar próximos estrenos.');
      },
      data: (movies) => movies.isEmpty
          ? const _EmptyMessage('No hay próximos estrenos disponibles.')
          : MovieListHorizontal(movies: movies, onMovieTap: onMovieTap),
    );
  }
}

/// Widget independiente para la sección de tendencias
class _TrendingMoviesSection extends StatelessWidget {
  final AsyncValue<List<MovieModel>> trendingMovies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const _TrendingMoviesSection({
    required this.trendingMovies,
    required this.isLoading,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return trendingMovies.when(
      loading: () =>
          const ShimmerText(text: "Cargando películas en tendencia..."),
      error: (error, stack) {
        printInDebugMode('❌ Error en tendencias: $error');
        return const _ErrorMessage('Error al cargar tendencias.');
      },
      data: (movies) => movies.isEmpty
          ? const _EmptyMessage('No hay películas en tendencia disponibles.')
          : MovieListHorizontal(movies: movies, onMovieTap: onMovieTap),
    );
  }
}

/// Widget independiente para la sección de recomendados
class _RecommendedMoviesSection extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const _RecommendedMoviesSection({
    required this.movies,
    required this.isLoading,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerText(text: "Cargando películas recomendadas...");
    }

    return movies.isEmpty
        ? const _EmptyMessage('No hay recomendaciones disponibles.')
        : MovieGridLimited(movies: movies, onMovieTap: onMovieTap);
  }
}

/// Widget reutilizable para mensajes de error
class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}

/// Widget reutilizable para mensajes de vacío
class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}
