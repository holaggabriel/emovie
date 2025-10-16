import 'package:emovie/utils/debug_print.dart';
import 'package:emovie/screens/widgets/shimmer_text.dart';
import 'package:emovie/utils/movie_filter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/mock_data.dart';
import '../models/filter_model.dart';
import '../models/movie_model.dart';
import 'widgets/filter_selector.dart';
import 'widgets/movie_list_horizontal.dart';
import 'widgets/movie_grid_limited.dart';
import 'widgets/section_title.dart';
import '../screens/movie_details_screen.dart';
import '../services/tmdb_service.dart';
import '../services/connectivity_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<FilterModel> filters;
  FilterModel? selectedFilter;

  List<MovieModel> upcomingMovies = [];
  List<MovieModel> trendingMovies = [];
  List<MovieModel> recommendedMovies = [];

  final MovieService _movieService = MovieService();
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isLoadingUpcoming = true;
  bool _isLoadingTrending = true;
  bool _isLoadingRecommended = false;

  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInternetAndLoadData();
    _loadFilters();
  }

  /// Verifica conexión y carga datos
  void _checkInternetAndLoadData() async {
    isOffline = !(await _connectivityService.isConnectedToInternet());

    // Cargar películas según el estado de conexión
    await _loadUpcomingMovies();
    await _loadTrendingMovies();
  }

  void _loadFilters() {
    filters = mockFilters;
    if (filters.isNotEmpty) selectedFilter = filters.first;
  }

  Future<void> _loadUpcomingMovies() async {
    setState(() => _isLoadingUpcoming = true);

    final box = Hive.box<MovieModel>('upcomingMovies');

    if (isOffline) {
      upcomingMovies = box.values.toList();
      printInDebugMode(
        '📦 Próximos estrenos cargados desde Hive: ${upcomingMovies.length}',
      );
      setState(() => _isLoadingUpcoming = false);
      return;
    }

    try {
      printInDebugMode('Intentando obtener próximos estrenos desde la API...');
      final movies = await _movieService.getUpcomingMovies();
      await box.clear();
      await box.addAll(movies);

      upcomingMovies = movies;
      printInDebugMode(
        '✅ Próximos estrenos cargados desde API: ${movies.length}',
      );
    } catch (e) {
      printInDebugMode('❌ Error al obtener próximos estrenos desde API: $e');
      upcomingMovies = box.values.toList();
      printInDebugMode(
        '📦 Cargando próximos estrenos desde Hive: ${upcomingMovies.length}',
      );
    } finally {
      setState(() => _isLoadingUpcoming = false);
    }
  }

  Future<void> _loadTrendingMovies() async {
    setState(() => _isLoadingTrending = true);

    final box = Hive.box<MovieModel>('trendingMovies');

    if (isOffline) {
      trendingMovies = box.values.toList();
      printInDebugMode(
        '📦 Películas trending cargadas desde Hive: ${trendingMovies.length}',
      );
      _applyFilter(selectedFilter);
      setState(() => _isLoadingTrending = false);
      return;
    }

    try {
      printInDebugMode('Intentando obtener películas trending desde la API...');
      final movies = await _movieService.getTrendingMovies();
      await box.clear();
      await box.addAll(movies);

      trendingMovies = movies;
      printInDebugMode(
        '✅ Películas trending cargadas desde API: ${movies.length}',
      );
    } catch (e) {
      printInDebugMode('❌ Error al obtener películas trending desde API: $e');
      trendingMovies = box.values.toList();
      printInDebugMode(
        '📦 Películas trending cargadas desde Hive: ${trendingMovies.length}',
      );
    } finally {
      _applyFilter(selectedFilter);
      setState(() => _isLoadingTrending = false);
    }
  }

  void _onFilterSelected(FilterModel filter) {
    setState(() {
      selectedFilter = filter;
      _applyFilter(filter);
    });
  }

void _applyFilter(FilterModel? filter) {
  if (filter == null) return;

  setState(() => _isLoadingRecommended = true);

  recommendedMovies = filterMovies(trendingMovies, filter);

  setState(() => _isLoadingRecommended = false);
}


  void _navigateToDetails(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies', style: TextStyle(color: Colors.white)),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  SectionTitle('Próximos estrenos'),
                  _isLoadingUpcoming
                      ? const ShimmerText(
                          text: "Cargando películas próximas...",
                        )
                      : upcomingMovies.isEmpty
                      ? const Text(
                          'No hay próximos estrenos disponibles.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      : MovieListHorizontal(
                          movies: upcomingMovies,
                          onMovieTap: _navigateToDetails,
                        ),
                  const SizedBox(height: 16),
                  SectionTitle('Tendencias'),
                  _isLoadingTrending
                      ? const ShimmerText(
                          text: "Cargando películas en tendencia...",
                        )
                      : trendingMovies.isEmpty
                      ? const Text(
                          'No hay películas en tendencia disponibles.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      : MovieListHorizontal(
                          movies: trendingMovies,
                          onMovieTap: _navigateToDetails,
                        ),
                  const SizedBox(height: 16),
                  SectionTitle('Recomendados para ti'),
                  FilterSelector(
                    filters: filters,
                    onFilterSelected: _onFilterSelected,
                    selectedFilter: selectedFilter,
                  ),
                  const SizedBox(height: 16),
                  _isLoadingRecommended
                      ? const ShimmerText(
                          text: "Cargando películas recomendadas...",
                        )
                      : recommendedMovies.isEmpty
                      ? const Text(
                          'No hay recomendaciones disponibles.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      : MovieGridLimited(movies: recommendedMovies),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
