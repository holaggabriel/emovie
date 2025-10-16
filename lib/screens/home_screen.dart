import 'package:emovie/models/movie_genre_model.dart';
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
  List<MovieGenreModel> movieGenres = [];

  final MovieService _movieService = MovieService();
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isLoadingUpcoming = true;
  bool _isLoadingTrending = true;
  bool _isLoadingRecommended = false;

  bool isOffline = false;
  bool _genresLoaded =
      false; // Para evitar múltiples cargas de géneros. Solo cargar una vez al iniciar.

  @override
  void initState() {
    super.initState();
    _checkInternetAndLoadData();
    _loadFilters();
  }

  /// Verifica conexión y carga datos
  void _checkInternetAndLoadData() async {
    isOffline = !(await _connectivityService.isConnectedToInternet());
    await _loadMovieGenres();
    // Ejecutar en paralelo sin esperar a que cada una termine antes de iniciar la siguiente
    _loadUpcomingMovies();
    _loadTrendingMovies();
  }

  void _loadFilters() {
    filters = mockFilters;
    if (filters.isNotEmpty) selectedFilter = filters.first;
  }

  Future<void> _onRefresh() async {
    printInDebugMode('🔄 Usuario intentó recargar datos');

    // Siempre mostrar la animación de refresh
    await Future.delayed(const Duration(milliseconds: 300));

    // Verificar conexión
    final connected = await _connectivityService.isConnectedToInternet();
    isOffline = !connected;

    if (!connected) {
      printInDebugMode('⚠️ No hay conexión, no se realizará la petición');
      setState(() {}); // refrescar UI si es necesario
      return;
    }

    // Si hay conexión, recargar datos desde la API
    _loadUpcomingMovies();
    _loadTrendingMovies();
    _loadMovieGenres();
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
    // Evita que no se muestren recomendaciones al recargar, ya que depende de trending
    recommendedMovies.clear();
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

  Future<void> _loadMovieGenres() async {
    if (_genresLoaded) return;
    final box = Hive.box<MovieGenreModel>('movieGenres');

    if (isOffline) {
      // Cargar desde Hive si no hay conexión
      movieGenres = box.values.toList();
      printInDebugMode('📦 Géneros cargados desde Hive: ${movieGenres.length}');
      setState(() {});
      return;
    }

    try {
      printInDebugMode('Intentando obtener géneros desde la API...');
      final genres = await _movieService.getMovieGenres();

      // Limpiar box y guardar los nuevos géneros
      await box.clear();
      await box.addAll(genres);

      movieGenres = genres;
      _genresLoaded = true;
      printInDebugMode('✅ Géneros cargados desde API: ${genres.length}');
    } catch (e) {
      printInDebugMode('❌ Error al obtener géneros desde API: $e');

      // Si falla, cargar desde Hive
      movieGenres = box.values.toList();
      printInDebugMode('📦 Géneros cargados desde Hive: ${movieGenres.length}');
      _genresLoaded = false;
    } finally {
      setState(() {});
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
   Navigator.of(context).push(
       
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                 MovieDetailsScreen(movie: movie, allGenres: movieGenres),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var curve = Curves.easeInOut;
                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    );
                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    );
                  },
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // duración de la animación
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eMovies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 25),
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
              onRefresh: _onRefresh,
              color: Colors.white,
              backgroundColor: Colors.black,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
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
                  _isLoadingRecommended || _isLoadingTrending
                      ? const ShimmerText(
                          text: "Cargando películas recomendadas...",
                        )
                      : recommendedMovies.isEmpty
                      ? const Text(
                          'No hay recomendaciones disponibles.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      : MovieGridLimited(
                          movies: recommendedMovies,
                          onMovieTap: _navigateToDetails,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
