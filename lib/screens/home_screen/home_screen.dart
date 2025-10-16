import 'package:emovie/models/filter_model.dart';
import 'package:emovie/models/movie_genre_model.dart';
import 'package:emovie/models/movie_model.dart';
import 'package:emovie/providers/providers.dart';
import 'package:emovie/screens/home_screen/dialogs/my_about_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emovie/utils/debug_print.dart';
import 'package:emovie/widgets/shimmer_text.dart';
import 'package:emovie/screens/home_screen/widgets/filter_selector.dart';
import 'package:emovie/screens/home_screen/widgets/movie_list_horizontal.dart';
import 'package:emovie/screens/home_screen/widgets/movie_grid_limited.dart';
import 'package:emovie/screens/home_screen/widgets/section_title.dart';
import 'package:emovie/screens/movie_details_screen/movie_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() => isRefreshing = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final refreshAll = ref.read(refreshAllProvider);
    await refreshAll();

    if (mounted) setState(() => isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = ref.watch(isOfflineProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final filters = ref.watch(availableFiltersProvider);
    final loadingStates = ref.watch(loadingStateProvider);

    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final trendingMovies = ref.watch(trendingMoviesProvider);
    final recommendedMovies = ref.watch(recommendedMoviesProvider);
    final movieGenres = ref.watch(movieGenresProvider);

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
        title: GestureDetector(
          onTap: isRefreshing ? null : _refreshData,
          child: isRefreshing
              ? const ShimmerText(
                  text: "eMovie",
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                )
              : const Text(
                  'eMovie',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                  ),
                ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white38),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const MyAboutDialog(),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.black45,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              color: Colors.red,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(), // Expande la columna horizontalmente
                  if (isOffline) const SizedBox(height: 8),
                  const SectionTitle('Próximos estrenos'),
                  UpcomingMoviesSection(
                    upcomingMovies: upcomingMovies,
                    isLoading: loadingStates['upcoming']!,
                    onMovieTap: navigateToDetails,
                  ),
                  const SizedBox(height: 16),
                  const SectionTitle('Tendencias'),
                  TrendingMoviesSection(
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
                  RecommendedMoviesSection(
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
class UpcomingMoviesSection extends StatelessWidget {
  final AsyncValue<List<MovieModel>> upcomingMovies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const UpcomingMoviesSection({
    super.key,
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
        return const EmptyMessage('Error al cargar próximos estrenos.');
      },
      data: (movies) => movies.isEmpty
          ? const EmptyMessage('No hay próximos estrenos disponibles.')
          : MovieListHorizontal(movies: movies, onMovieTap: onMovieTap),
    );
  }
}

/// Widget independiente para la sección de tendencias
class TrendingMoviesSection extends StatelessWidget {
  final AsyncValue<List<MovieModel>> trendingMovies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const TrendingMoviesSection({
    super.key,
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
        return const EmptyMessage('Error al cargar tendencias.');
      },
      data: (movies) => movies.isEmpty
          ? const EmptyMessage('No hay películas en tendencia disponibles.')
          : MovieListHorizontal(movies: movies, onMovieTap: onMovieTap),
    );
  }
}

/// Widget independiente para la sección de recomendados
class RecommendedMoviesSection extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;
  final Function(MovieModel) onMovieTap;

  const RecommendedMoviesSection({
    super.key,
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
        ? const EmptyMessage('No hay recomendaciones disponibles.')
        : MovieGridLimited(movies: movies, onMovieTap: onMovieTap);
  }
}

/// Widget reutilizable para mensajes de vacío
class EmptyMessage extends StatelessWidget {
  final String message;

  const EmptyMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}
