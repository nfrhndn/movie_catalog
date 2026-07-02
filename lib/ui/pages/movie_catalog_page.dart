import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';
import '../../bloc/movie/movie_bloc.dart';
import '../../bloc/movie/movie_event.dart';
import '../../bloc/movie/movie_state.dart';
import '../../core/theme.dart';
import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_page.dart';

class MovieCatalogPage extends StatelessWidget {
  const MovieCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moviePageBackgroundColor,
      appBar: AppBar(
        backgroundColor: movieAppBarColor,
        centerTitle: true,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          children: [
            const Text(
              'Movie Catalog',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            StreamBuilder<int>(
              stream: context.read<MovieRepository>().getActiveUsersCount(),
              builder: (context, snapshot) {
                final viewersCount = snapshot.data ?? 1500;
                return Text(
                  'Online - $viewersCount active viewers',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.greenAccent,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final favoriteCount = state.favoriteMovieIds.length;
              return IconButton(
                tooltip: 'Daftar favorite',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Anda memiliki $favoriteCount film favorit',
                      ),
                    ),
                  );
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.favorite, color: Colors.white),
                    if (favoriteCount > 0)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: movieAccentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: movieAppBarColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            favoriteCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieLoaded && state.isFromCache) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Menampilkan data offline dari cache'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MovieInitial || state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(color: movieAccentColor),
            );
          }

          if (state is MovieError) {
            return _MovieErrorView(message: state.message);
          }

          if (state is! MovieLoaded || state.movies.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data film.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return _MovieListView(
            movies: state.movies,
            isFromCache: state.isFromCache,
          );
        },
      ),
    );
  }
}

class _MovieErrorView extends StatelessWidget {
  const _MovieErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: movieAccentColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: movieAccentColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<MovieBloc>().add(LoadMoviesEvent());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieListView extends StatelessWidget {
  const _MovieListView({required this.movies, required this.isFromCache});

  final List<Movie> movies;
  final bool isFromCache;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length + (isFromCache ? 1 : 0),
      itemBuilder: (context, index) {
        if (isFromCache && index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: movieAccentColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: movieAccentColor),
            ),
            child: const Row(
              children: [
                Icon(Icons.offline_bolt_rounded, color: movieAccentColor),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Menampilkan data offline dari cache.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final movieIndex = isFromCache ? index - 1 : index;
        final movie = movies[movieIndex];

        return BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            final isFavorite = state.isFavorite(movie.id);

            return MovieCard(
              movie: movie,
              isFavorite: isFavorite,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MovieDetailPage(movie: movie);
                    },
                  ),
                );
              },
              onToggleFavorite: () {
                context.read<FavoriteBloc>().add(ToggleFavoriteEvent(movie));
              },
            );
          },
        );
      },
    );
  }
}
