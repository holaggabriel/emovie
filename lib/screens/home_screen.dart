import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/movie_model.dart';
import '../widgets/filter_selector.dart';
import '../widgets/movie_list_horizontal.dart';
import '../widgets/movie_grid_limited.dart';
import '../widgets/section_title.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CategoryModel> categories;
  CategoryModel? selectedCategory;

  late List<MovieModel> movies;

  @override
  void initState() {
    super.initState();
    categories = mockCategories;
    movies = mockMovies;
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() => selectedCategory = category);
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Próximos estrenos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MovieListHorizontal(movies: movies),
            const SizedBox(height: 16),
SectionTitle('Próximos estrenos'),
            MovieListHorizontal(movies: movies),
            const SizedBox(height: 16),
SectionTitle('Recomendados para ti'),
            FilterSelector(
              categories: categories,
              onCategorySelected: _onCategorySelected,
            ),
            const SizedBox(height: 14.0),
            MovieGridLimited(movies: movies),
          ],
        ),
      ),
    );
  }
}
