import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String env;
  final String apiBaseUrl;
  final String apiToken;
  final String imageBaseUrl;

  // Instancia privada estática
  static Config? _instance;

  // Constructor privado
  Config._({
    required this.env,
    required this.apiBaseUrl,
    required this.apiToken,
    required this.imageBaseUrl,
  });

  // Getter singleton
  static Config get instance {
    if (_instance == null) {
      throw Exception(
        "Config no ha sido inicializada. Llama a Config.init(env) primero.",
      );
    }
    return _instance!;
  }

  // Inicialización singleton
  static Future<void> init(String env) async {
    if (_instance != null) return; // ya inicializada

    // Cargar variables de entorno solo en dev
    if (env != 'prod') {
      await dotenv.load(fileName: ".env");
    }

    if (env == 'prod') {
      const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
      const token = String.fromEnvironment('API_TOKEN', defaultValue: '');
      const imageBase = String.fromEnvironment(
        'IMAGE_BASE_URL',
        defaultValue: '',
      );
      _instance = Config._(
        env: 'prod',
        apiBaseUrl: baseUrl,
        apiToken: token,
        imageBaseUrl: imageBase,
      );
    } else {
      final baseUrl =
          dotenv.env['API_BASE_URL'] ?? 'https://api-dev.themoviedb.org/3';
      final token = dotenv.env['API_TOKEN'] ?? 'dev_token';
      final imageBase =
          dotenv.env['IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p/w500';
      _instance = Config._(
        env: env,
        apiBaseUrl: baseUrl,
        apiToken: token,
        imageBaseUrl: imageBase,
      );
    }
  }
}
