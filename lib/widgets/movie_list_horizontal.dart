import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'movie_card.dart';

class MovieListHorizontal extends StatelessWidget {
  final List<MovieModel> movies;

  const MovieListHorizontal({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}