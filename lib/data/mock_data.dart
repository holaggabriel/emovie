import '../models/category_model.dart';
import '../models/movie_model.dart';

final List<CategoryModel> mockCategories = [
  const CategoryModel(id: 1, name: 'En español'),
  const CategoryModel(id: 2, name: 'Lanzadas en 1993'),
  const CategoryModel(id: 3, name: 'Acción'),
  const CategoryModel(id: 4, name: 'Comedia'),
];

final List<MovieModel> mockMovies = [
  const MovieModel(
    id: '1',
    name: 'Avengers',
    imageUrl: 'https://imgs.search.brave.com/M07iCKg_hdxLnJpElT07cHd75juaTFPR0KTrfVDCSlE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZS5zbGlkZXNoYXJl/Y2RuLmNvbS9wb3J0/YWRhc2RlcGVsY3Vs/YXMtMTIwODA1MTYw/NDA5LXBocGFwcDAx/Lzg1L1BvcnRhZGFz/LWRlLWxhcy1wZWxp/Y3VsYXMtNS0zMjAu/anBn',
  ),
  const MovieModel(
    id: '2',
    name: 'Inception',
    imageUrl: 'https://image.tmdb.org/t/p/w500/inception.jpg',
  ),
  const MovieModel(
    id: '3',
    name: 'Interstellar',
    imageUrl: 'https://image.tmdb.org/t/p/w500/interstellar.jpg',
  ),
  const MovieModel(
    id: '4',
    name: 'The Dark Knight',
    imageUrl: 'https://image.tmdb.org/t/p/w500/dark_knight.jpg',
  ),
  const MovieModel(
    id: '5',
    name: 'Tenet',
    imageUrl: 'https://image.tmdb.org/t/p/w500/tenet.jpg',
  ),
  const MovieModel(
    id: '6',
    name: 'Dune',
    imageUrl: 'https://image.tmdb.org/t/p/w500/dune.jpg',
  ),
  const MovieModel(
    id: '7',
    name: 'Matrix',
    imageUrl: 'https://image.tmdb.org/t/p/w500/matrix.jpg',
  ),
];
