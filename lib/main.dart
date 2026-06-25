import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/favorite_bloc.dart';
import 'core/theme.dart';
import 'repositories/movie_repository.dart';
import 'ui/pages/movie_catalog_page.dart';

void main() {
  runApp(const MovieCatalogApp());
}

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan RepositoryProvider untuk inject repository
    return RepositoryProvider(
      create: (context) => MovieRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FavoriteBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie Catalog',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: movieAccentColor),
            useMaterial3: true,
          ),
          home: const MovieCatalogPage(),
        ),
      ),
    );
  }
}
