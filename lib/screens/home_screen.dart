import 'package:emovie/widgets/shimmer_text.dart';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/filter_model.dart';
import '../models/movie_model.dart';
import '../widgets/filter_selector.dart';
import '../widgets/movie_list_horizontal.dart';
import '../widgets/movie_grid_limited.dart';
import '../widgets/section_title.dart';
import '../screens/movie_details_screen.dart';
import '../services/tmdb_service.dart';

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

  // 🔹 Estados de carga
  bool _isLoadingUpcoming = true;
  bool _isLoadingTrending = true;
  bool _isLoadingRecommended = false;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _loadUpcomingMovies();
    _loadTrendingMovies();
  }

  void _loadFilters() {
    filters = mockFilters;
    if (filters.isNotEmpty) {
      selectedFilter = filters.first; // primer filtro por defecto
    }
  }

  void _loadUpcomingMovies() async {
    setState(() => _isLoadingUpcoming = true);
    try {
      final movies = await _movieService.getUpcomingMovies();
      setState(() {
        upcomingMovies = movies;
        _isLoadingUpcoming = false;
      });
    } catch (e) {
      print('Error al obtener próximos estrenos: $e');
      setState(() => _isLoadingUpcoming = false);
    }
  }

  void _loadTrendingMovies() async {
    setState(() => _isLoadingTrending = true);
    try {
      final movies = await _movieService.getTrendingMovies();
      setState(() {
        trendingMovies = movies;
        _isLoadingTrending = false;
      });

      // Aplicar filtro por defecto
      _applyFilter(selectedFilter);
    } catch (e) {
      print('Error al obtener películas trending: $e');
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

    final filtered = trendingMovies
        .where((movie) {
          switch (filter.type) {
            case FilterType.language:
              return movie.originalLanguage == filter.filterValue;
            case FilterType.releaseYear:
              return movie.releaseDate.startsWith(filter.filterValue);
          }
        })
        .take(6)
        .toList();

    setState(() {
      recommendedMovies = filtered;
      _isLoadingRecommended = false;
    });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Sección: Próximos estrenos
            SectionTitle('Próximos estrenos'),
            _isLoadingUpcoming
                ? const ShimmerText(
                    text: "Cargando películas próximas...",
                  )
                : upcomingMovies.isEmpty
                ? Text(
                  'No hay próximos estrenos disponibles...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                )
                : MovieListHorizontal(
                    movies: upcomingMovies,
                    onMovieTap: _navigateToDetails,
                  ),

            const SizedBox(height: 16),

            // 🔹 Sección: Tendencias
            SectionTitle('Tendencias'),
            _isLoadingTrending
                ? const ShimmerText(
                    text: "Cargando películas en tendencia...",
                  )
                : trendingMovies.isEmpty
                ? Text(
                  'No hay películas en tendencia disponibles.',
                   style: TextStyle(color: Colors.white70, fontSize: 14),
                )
                : MovieListHorizontal(
                    movies: trendingMovies,
                    onMovieTap: _navigateToDetails,
                  ),

            const SizedBox(height: 16),

            // 🔹 Sección: Recomendados
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
                ? Text(
                  'No hay recomendaciones disponibles.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                )
                : MovieGridLimited(movies: recommendedMovies),
          ],
        ),
      ),
    );
  }
}
