import 'package:flutter/material.dart';

void main() {
  runApp(const MovieCatalogApp());
}

class Movie {
  const Movie({
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  final String title;
  final String releaseDate;
  final double rating;
  final String description;
  final String imageUrl;
}

const List<Movie> movies = [
  Movie(
    title: 'Inception',
    releaseDate: '2010-07-15',
    rating: 8.4,
    description:
        'A skilled thief enters dreams to steal secrets, then gets one chance to plant an idea instead.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
  ),
  Movie(
    title: 'Interstellar',
    releaseDate: '2014-11-07',
    rating: 8.6,
    description:
        'A team of explorers travels through a wormhole to find a new home for humanity.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
  ),
  Movie(
    title: 'Tenet',
    releaseDate: '2020-08-22',
    rating: 7.3,
    description:
        'A secret agent learns to move through inverted time to prevent a global catastrophe.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/aCIFMriQh8rvhxpN1IWGgvH0Tlg.jpg',
  ),
  Movie(
    title: 'The Dark Knight Rises',
    releaseDate: '2012-07-16',
    rating: 7.8,
    description:
        'Batman returns from exile when Gotham faces a brutal enemy and a city-wide reckoning.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/hr0L2aueqlP2BYUblTTjmtn0hw4.jpg',
  ),
  Movie(
    title: 'Avatar: The Way of Water',
    releaseDate: '2022-12-14',
    rating: 7.6,
    description:
        'Jake Sully and his family seek refuge with an ocean clan while an old threat returns.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
  ),
];

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MovieCatalogPage(),
    );
  }
}

class MovieCatalogPage extends StatelessWidget {
  const MovieCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Movie Catalog',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return MovieCard(movie: movie);
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                movie.imageUrl,
                width: 90,
                height: 135,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 135,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.movie, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie.releaseDate,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFC107),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade800, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
