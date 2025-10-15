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
    try {
      final movies = await _movieService.getUpcomingMovies();
      setState(() {
        upcomingMovies = movies;
      });
    } catch (e) {
      print('Error al obtener próximos estrenos: $e');
    }
  }

  void _loadTrendingMovies() async {
    try {
      final movies = await _movieService.getTrendingMovies();
      setState(() {
        trendingMovies = movies;
      });

      // Aplicar filtro por defecto
      _applyFilter(selectedFilter);
    } catch (e) {
      print('Error al obtener películas trending: $e');
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

    final filtered = trendingMovies.where((movie) {
      switch (filter.type) {
        case FilterType.language:
          return movie.originalLanguage == filter.filterValue;
        case FilterType.releaseYear:
          return movie.releaseDate.startsWith(filter.filterValue);
      }
    }).take(6).toList();

    setState(() {
      recommendedMovies = filtered;
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
            SectionTitle('Próximos estrenos'),
            MovieListHorizontal(
              movies: upcomingMovies,
              onMovieTap: _navigateToDetails,
            ),
            const SizedBox(height: 16),
            SectionTitle('Tendencias'),
            MovieListHorizontal(
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
            const SizedBox(height: 14),
            MovieGridLimited(
              movies: recommendedMovies,
            ),
          ],
        ),
      ),
    );
  }
}
