import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie_model.dart';
import 'widgets/tag.dart';
import 'widgets/trailer_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  String _getGenres(List<int> genreIds) {
    const genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };

    return genreIds.map((id) => genreMap[id] ?? 'Unknown').join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final releaseYear = movie.releaseDate.isNotEmpty
        ? movie.releaseDate.split('-').first
        : 'N/A';
    final language = movie.originalLanguage.toUpperCase();
    final rating = movie.voteAverage.toStringAsFixed(1);
    final genres = _getGenres(movie.genreIds);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Imagen de fondo
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: movie.posterPath,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color(0xFF1E1E1E),
                highlightColor: const Color(0xFF2A2A2A),
                child: Container(color: const Color(0xFF2A2A2A)),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800]
              ),
            ),
          ),

          /// Degradado superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Botón de retroceso
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// Contenedor inferior con la información
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 1),
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tag(
                            text: releaseYear,
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w400,
                            textColor: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Tag(
                            text: language,
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            textColor: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Tag(
                            text: rating,
                            backgroundColor: const Color(0xFFF6C700),
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            leadingIcon: const Icon(
                              Icons.star,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        genres,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TrailerButton(onTap: () {}),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "TRAMA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : 'No plot available.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
