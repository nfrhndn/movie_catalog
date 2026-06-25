import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';
import '../../core/theme.dart';
import '../../models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moviePageBackgroundColor,
      appBar: AppBar(
        backgroundColor: movieAppBarColor,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(movie.title),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFavorite = state.isFavorite(movie.title);
              return IconButton(
                tooltip: isFavorite ? 'Hapus dari favorite' : 'Tambah favorite',
                onPressed: () {
                  context.read<FavoriteBloc>().add(ToggleFavoriteEvent(movie));
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? movieAccentColor : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.imageUrl,
                width: 210,
                height: 315,
                cacheWidth: 420,
                cacheHeight: 630,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 210,
                    height: 315,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 52,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie.releaseDate,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC107),
                size: 22,
              ),
              const SizedBox(width: 4),
              Text(
                movie.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFavorite = state.isFavorite(movie.title);
              return FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: movieAccentColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<FavoriteBloc>().add(ToggleFavoriteEvent(movie));
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(
                  isFavorite ? 'Hapus dari Favorite' : 'Tambah ke Favorite',
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          const Text(
            'Deskripsi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            movie.description,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
