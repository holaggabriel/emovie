import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 120,
    this.height = 180,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: movie.posterPath,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: const Color(0xFF1E1E1E),
              highlightColor: const Color(0xFF2A2A2A),
              child: Container(
                width: width,
                height: height,
                color: const Color(0xFF2A2A2A),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
