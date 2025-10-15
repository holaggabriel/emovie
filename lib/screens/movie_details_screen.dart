import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../widgets/tag.dart';
import '../widgets/trailer_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Botón de retroceso
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Contenido deslizable
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Indicador de arrastre
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Título y metadata
                      Column(
                        children: [
                          Text(
                            movie.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.25,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tags en una sola fila
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Tag(
                                text: "2013",
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.8,
                                ),
                                fontWeight: FontWeight.w400,
                                textColor: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Tag(
                                text: "EN",
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.8,
                                ),

                                textColor: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Tag(
                                text: "8.0",
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

                          // Géneros
                          Text(
                            "Heartfelt · Romance · Sci-Fi · Drama",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Botón y descripción
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrailerButton(
                            onTap: () {
                              print("Se presionó el botón de tráiler");
                            },
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            "MOVIE PLOT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.25,
                            ),
                          ),
                          const SizedBox(height: 8),

                          const Text(
                            "In a near future, a lonely man develops an emotional relationship with an intelligent operating system designed to meet his every need. As their relationship deepens, he learns more about love, identity, and what it means to be human. The boundaries between the digital and physical world begin to blur as his emotions evolve in unexpected ways.",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              letterSpacing: 0.25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
