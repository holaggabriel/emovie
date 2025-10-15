import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _bearerToken = 'aqui_va_el_token';

  // Obtener películas en tendencia (trending)
  Future<List<MovieModel>> getTrendingMovies() async {
    final url = Uri.parse('$_baseUrl/trending/movie/day?language=en-MX');

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Error al cargar películas trending: ${response.statusCode}');
    }
  }

  // Obtener próximos estrenos (upcoming)
  Future<List<MovieModel>> getUpcomingMovies({String language = 'en-US', int page = 1}) async {
    final url = Uri.parse('$_baseUrl/movie/upcoming?language=$language&page=$page');

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Error al cargar próximos estrenos: ${response.statusCode}');
    }
  }
}
