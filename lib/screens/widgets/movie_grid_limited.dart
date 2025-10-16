import 'package:flutter/material.dart';
import '../../models/movie_model.dart';
import 'movie_card.dart';

class MovieGridLimited extends StatelessWidget {
  final List<MovieModel> movies;
  final int maxItems;
  final void Function(MovieModel)? onMovieTap;

  const MovieGridLimited({
    super.key,
    required this.movies,
    this.maxItems = 6,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayMovies = movies.length > maxItems ? movies.sublist(0, maxItems) : movies;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2 / 3,
      ),
      itemCount: displayMovies.length,
      itemBuilder: (context, index) {
        final movie = displayMovies[index];
        return MovieCard(
          movie: movie,
          onTap: () {
            if (onMovieTap != null) {
              onMovieTap!(movie);
            }
          },
        );
      },
    );
  }
}
