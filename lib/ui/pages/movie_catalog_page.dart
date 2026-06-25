import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';
import '../../core/theme.dart';
import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_page.dart';

class MovieCatalogPage extends StatefulWidget {
  const MovieCatalogPage({super.key});

  @override
  State<MovieCatalogPage> createState() => _MovieCatalogPageState();
}

class _MovieCatalogPageState extends State<MovieCatalogPage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    // Inisialisasi future saat halaman pertama dibuat
    _moviesFuture = context.read<MovieRepository>().getMovies();
  }

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
            // STREAM BUILDER IMPLEMENTATION
            StreamBuilder<int>(
              stream: context.read<MovieRepository>().getActiveUsersCount(),
              builder: (context, snapshot) {
                final viewersCount = snapshot.data ?? 1500;
                return Text(
                  '🟢 $viewersCount active viewers',
                  style: const TextStyle(fontSize: 12, color: Colors.greenAccent),
                );
              },
            ),
          ],
        ),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final favoriteCount = state.favoriteMovieTitles.length;
              return IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Anda memiliki $favoriteCount film favorit')),
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
                            border: Border.all(color: movieAppBarColor, width: 1.5),
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
      // FUTURE BUILDER IMPLEMENTATION
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // State: Menunggu data (Loading)
            return const Center(
              child: CircularProgressIndicator(color: movieAccentColor),
            );
          } else if (snapshot.hasError) {
            // State: Error
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // State: Data kosong
            return const Center(
              child: Text(
                'Tidak ada data film.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // State: Data berhasil diambil
          final movies = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  final isFavorite = state.isFavorite(movie.title);

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
        },
      ),
    );
  }
}
