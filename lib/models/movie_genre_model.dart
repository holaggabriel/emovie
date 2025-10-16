import 'package:hive/hive.dart';

part 'movie_genre_model.g.dart';

@HiveType(typeId: 1)
class MovieGenreModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  MovieGenreModel({
    required this.id,
    required this.name,
  });

  /// Crear una instancia desde un JSON
  factory MovieGenreModel.fromJson(Map<String, dynamic> json) {
    return MovieGenreModel(
      id: json['id'],
      name: json['name'],
    );
  }

  /// Convertir el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'MovieGenreModel(id: $id, name: $name)';
}
