import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 120,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          movie.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}