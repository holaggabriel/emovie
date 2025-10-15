import '../models/category_model.dart';
import '../models/movie_model.dart';

final List<CategoryModel> mockCategories = [
  const CategoryModel(id: 1, name: 'En español'),
  const CategoryModel(id: 2, name: 'Lanzadas en 1993'),
  const CategoryModel(id: 3, name: 'Acción'),
  const CategoryModel(id: 4, name: 'Comedia'),
];

final List<MovieModel> mockMovies = [
  MovieModel(
    id: 1,
    title: 'Avengers',
    originalTitle: 'The Avengers',
    overview: 'Los superhéroes más poderosos se unen para salvar el mundo.',
    posterPath: 'https://image.tmdb.org/t/p/w500/avengers.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/avengers_backdrop.jpg',
    releaseDate: '2012-05-04',
    voteAverage: 8.0,
    voteCount: 15000,
    genreIds: [28, 12, 878], // Acción, Aventura, Ciencia ficción
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 2,
    title: 'Inception',
    originalTitle: 'Inception',
    overview: 'Un ladrón que roba secretos a través del sueño es contratado para implantar una idea.',
    posterPath: 'https://image.tmdb.org/t/p/w500/inception.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/inception_backdrop.jpg',
    releaseDate: '2010-07-16',
    voteAverage: 8.8,
    voteCount: 21000,
    genreIds: [28, 878, 12], // Acción, Ciencia ficción, Aventura
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 3,
    title: 'Interstellar',
    originalTitle: 'Interstellar',
    overview: 'Un grupo de exploradores viaja a través de un agujero de gusano para salvar a la humanidad.',
    posterPath: 'https://image.tmdb.org/t/p/w500/interstellar.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/interstellar_backdrop.jpg',
    releaseDate: '2014-11-07',
    voteAverage: 8.6,
    voteCount: 16000,
    genreIds: [12, 18, 878], // Aventura, Drama, Ciencia ficción
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 4,
    title: 'The Dark Knight',
    originalTitle: 'The Dark Knight',
    overview: 'Batman se enfrenta al Joker, un criminal que siembra el caos en Gotham.',
    posterPath: 'https://image.tmdb.org/t/p/w500/dark_knight.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/dark_knight_backdrop.jpg',
    releaseDate: '2008-07-18',
    voteAverage: 9.0,
    voteCount: 23000,
    genreIds: [18, 28, 80, 53], // Drama, Acción, Crimen, Suspense
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 5,
    title: 'Tenet',
    originalTitle: 'Tenet',
    overview: 'Un agente secreto lucha para prevenir la Tercera Guerra Mundial usando el tiempo invertido.',
    posterPath: 'https://image.tmdb.org/t/p/w500/tenet.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/tenet_backdrop.jpg',
    releaseDate: '2020-08-26',
    voteAverage: 7.5,
    voteCount: 9000,
    genreIds: [28, 53, 878], // Acción, Suspense, Ciencia ficción
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 6,
    title: 'Dune',
    originalTitle: 'Dune',
    overview: 'En un futuro lejano, Paul Atreides debe proteger a su familia y controlar Arrakis.',
    posterPath: 'https://image.tmdb.org/t/p/w500/dune.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/dune_backdrop.jpg',
    releaseDate: '2021-10-22',
    voteAverage: 8.2,
    voteCount: 12000,
    genreIds: [12, 18, 878], // Aventura, Drama, Ciencia ficción
    originalLanguage: 'en',
  ),
  MovieModel(
    id: 7,
    title: 'Matrix',
    originalTitle: 'The Matrix',
    overview: 'Un hacker descubre que el mundo es una simulación y lucha por la libertad de la humanidad.',
    posterPath: 'https://image.tmdb.org/t/p/w500/matrix.jpg',
    backdropPath: 'https://image.tmdb.org/t/p/w500/matrix_backdrop.jpg',
    releaseDate: '1999-03-31',
    voteAverage: 8.7,
    voteCount: 18000,
    genreIds: [28, 878], // Acción, Ciencia ficción
    originalLanguage: 'en',
  ),
];
