import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/favorite_bloc.dart';
import 'bloc/favorite_event.dart';
import 'bloc/movie/movie_bloc.dart';
import 'bloc/movie/movie_event.dart';
import 'core/theme.dart';
import 'repositories/movie_repository.dart';
import 'ui/pages/movie_catalog_page.dart';

void main() {
  runApp(const MovieCatalogApp());
}

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({super.key, this.movieRepository});

  final MovieRepository? movieRepository;

  @override
  Widget build(BuildContext context) {
    final repository = movieRepository ?? MovieRepository();

    return RepositoryProvider(
      create: (context) => repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MovieBloc(context.read<MovieRepository>())
                  ..add(LoadMoviesEvent()),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc()..add(LoadFavoritesEvent()),
          ),
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
