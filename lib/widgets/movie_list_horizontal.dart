import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'movie_card.dart';

class MovieListHorizontal extends StatelessWidget {
  final List<MovieModel> movies;
  final void Function(MovieModel)? onMovieTap;

  const MovieListHorizontal({
    super.key,
    required this.movies,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () {
              if (onMovieTap != null) {
                onMovieTap!(movie);
              }
            },
          );
        },
      ),
    );
  }
}
