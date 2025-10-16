import 'package:emovie/models/movie_genre_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/movie_model.dart';
import 'widgets/tag.dart';
import 'widgets/trailer_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;
  final List<MovieGenreModel> allGenres;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
    required this.allGenres,
  });

  String _getGenres(List<int> genreIds) {
    final genreMap = {for (var g in allGenres) g.id: g.name};
    return genreIds.map((id) => genreMap[id] ?? 'Unknown').join('  •  ');
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
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey[800]),
            ),
          ),

          /// Degradado superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                // border: const Border(
                //   bottom: BorderSide(color: Colors.yellow, width: 2),
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Botón de retroceso
          Positioned(
            top: 30,
            left: 25,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          /// Contenedor inferior con la información
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              width: double.infinity,
              decoration: BoxDecoration(
                // border: const Border(
                //   top: BorderSide(color: Colors.yellow, width: 2),
                // ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.6),
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
                          Tag(text: releaseYear),
                          const SizedBox(width: 8),
                          Tag(text: language),
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
