import 'dart:convert';
import 'package:emovie/config/config.dart';
import 'package:emovie/models/movie_genre_model.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  final String _baseUrl = Config.instance.apiBaseUrl;
  final String _bearerToken = Config.instance.apiToken;

  /// Idioma por defecto para todas las llamadas
  String defaultLanguage = 'es-MX';

  /// Obtener películas en tendencia (trending)
  Future<List<MovieModel>> getTrendingMovies({String? language}) async {
    final lang = language ?? defaultLanguage;
    final url = Uri.parse('$_baseUrl/trending/movie/day?language=$lang');

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
      throw Exception(
        'Error al cargar películas trending: ${response.statusCode}',
      );
    }
  }

  /// Obtener próximos estrenos (upcoming)
  Future<List<MovieModel>> getUpcomingMovies({
    String? language,
    int page = 1,
  }) async {
    final lang = language ?? defaultLanguage;
    final url = Uri.parse('$_baseUrl/movie/upcoming?language=$lang&page=$page');

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
      throw Exception(
        'Error al cargar próximos estrenos: ${response.statusCode}',
      );
    }
  }

  /// Obtener lista de géneros de películas
  Future<List<MovieGenreModel>> getMovieGenres({String? language}) async {
    final lang = language ?? defaultLanguage;
    final url = Uri.parse('$_baseUrl/genre/movie/list?language=$lang');

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List genres = data['genres'];
      return genres.map((g) => MovieGenreModel.fromJson(g)).toList();
    } else {
      throw Exception('Error al cargar géneros: ${response.statusCode}');
    }
  }
}
