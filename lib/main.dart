import 'package:emovie/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'screens/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Iniciilización de Hive
  await Hive.initFlutter();
 
  // Registrar adapter de MovieModel
  Hive.registerAdapter(MovieModelAdapter());

  // Abrir boxes
  await Hive.openBox<MovieModel>('upcomingMovies');
  await Hive.openBox<MovieModel>('trendingMovies');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMovie',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
