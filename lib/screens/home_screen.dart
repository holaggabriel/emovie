import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/category_model.dart';
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
  late List<CategoryModel> categories;
  CategoryModel? selectedCategory;

  // Listas para películas
  List<MovieModel> upcomingMovies = [];
  List<MovieModel> trendingMovies = [];

  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadUpcomingMovies();   // Próximos estrenos desde API
    _loadTrendingMovies();   // Tendencias desde API
  }

  void _loadCategories() {
    categories = mockCategories;
  }

  // Próximos estrenos desde API
  void _loadUpcomingMovies() async {
    try {
      final movies = await _movieService.getUpcomingMovies();
      setState(() {
        upcomingMovies = movies;
      });

      for (var movie in movies) {
        print('Upcoming: ${movie.title}');
      }
    } catch (e) {
      print('Error al obtener próximos estrenos: $e');
    }
  }

  // Películas trending desde API
  void _loadTrendingMovies() async {
    try {
      final movies = await _movieService.getTrendingMovies();
      setState(() {
        trendingMovies = movies;
      });

      for (var movie in movies) {
        print('Trending: ${movie.title}');
      }
    } catch (e) {
      print('Error al obtener películas trending: $e');
    }
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() => selectedCategory = category);
  }

  void _navigateToDetails(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
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
        padding: const EdgeInsets.only(top: 5, right: 16, bottom: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('Próximos estrenos'),
            MovieListHorizontal(
              movies: upcomingMovies,  // API
              onMovieTap: _navigateToDetails,
            ),
            const SizedBox(height: 16),
            SectionTitle('Tendencias'),
            MovieListHorizontal(
              movies: trendingMovies,   // API
              onMovieTap: _navigateToDetails,
            ),
            const SizedBox(height: 16),
            SectionTitle('Recomendados para ti'),
            FilterSelector(
              categories: categories,
              onCategorySelected: _onCategorySelected,
            ),
            const SizedBox(height: 14.0),
            MovieGridLimited(
              movies: mockMovies,       // Siempre mock
            ),
          ],
        ),
      ),
    );
  }
}
