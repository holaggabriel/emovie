import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'movie_card.dart';

class MovieGridLimited extends StatelessWidget {
  final List<MovieModel> movies;
  final int maxItems;

  const MovieGridLimited({
    super.key,
    required this.movies,
    this.maxItems = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayMovies = movies.length > maxItems ? movies.sublist(0, maxItems) : movies;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // evita scroll dentro del grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 3 columnas
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2/3, // relación ancho/alto similar a MovieCard
      ),
      itemCount: displayMovies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: displayMovies[index]);
      },
    );
  }
}