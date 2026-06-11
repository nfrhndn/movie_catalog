import 'package:flutter/material.dart';

const Color movieAppBarColor = Color(0xFF10131A);
const Color moviePageBackgroundColor = Color(0xFF171D27);
const Color movieAccentColor = Color(0xFFE50914);

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

class MovieCatalogApp extends StatefulWidget {
  const MovieCatalogApp({super.key});

  @override
  State<MovieCatalogApp> createState() => _MovieCatalogAppState();
}

class _MovieCatalogAppState extends State<MovieCatalogApp> {
  final Set<String> _favoriteMovieTitles = {};

  bool _isFavorite(Movie movie) {
    return _favoriteMovieTitles.contains(movie.title);
  }

  void _toggleFavorite(Movie movie) {
    setState(() {
      if (_isFavorite(movie)) {
        _favoriteMovieTitles.remove(movie.title);
      } else {
        _favoriteMovieTitles.add(movie.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: movieAccentColor),
        useMaterial3: true,
      ),
      home: MovieCatalogPage(
        favoriteMovieTitles: _favoriteMovieTitles,
        onToggleFavorite: _toggleFavorite,
      ),
    );
  }
}

class MovieCatalogPage extends StatelessWidget {
  const MovieCatalogPage({
    super.key,
    required this.favoriteMovieTitles,
    required this.onToggleFavorite,
  });

  final Set<String> favoriteMovieTitles;
  final ValueChanged<Movie> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = movies.where((movie) {
      return favoriteMovieTitles.contains(movie.title);
    }).toList();

    return Scaffold(
      backgroundColor: moviePageBackgroundColor,
      appBar: AppBar(
        backgroundColor: movieAppBarColor,
        centerTitle: true,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Movie Catalog',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          FavoriteMenuButton(
            favoriteMovies: favoriteMovies,
            onRemoveFavorite: onToggleFavorite,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isFavorite = favoriteMovieTitles.contains(movie.title);

          return MovieCard(
            movie: movie,
            isFavorite: isFavorite,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MovieDetailPage(
                      movie: movie,
                      initialIsFavorite: isFavorite,
                      onToggleFavorite: onToggleFavorite,
                    );
                  },
                ),
              );
            },
            onToggleFavorite: () => onToggleFavorite(movie),
          );
        },
      ),
    );
  }
}

class FavoriteMenuButton extends StatelessWidget {
  const FavoriteMenuButton({
    super.key,
    required this.favoriteMovies,
    required this.onRemoveFavorite,
  });

  final List<Movie> favoriteMovies;
  final ValueChanged<Movie> onRemoveFavorite;

  @override
  Widget build(BuildContext context) {
    final favoriteCount = favoriteMovies.length;

    return PopupMenuButton<Movie>(
      tooltip: 'Daftar favorite',
      offset: const Offset(0, 48),
      color: Colors.white,
      itemBuilder: (context) {
        if (favoriteMovies.isEmpty) {
          return [
            const PopupMenuItem<Movie>(
              enabled: false,
              child: Text('Belum ada favorite'),
            ),
          ];
        }

        return favoriteMovies.map((movie) {
          return PopupMenuItem<Movie>(
            value: movie,
            child: SizedBox(
              width: 240,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      movie.imageUrl,
                      width: 38,
                      height: 56,
                      cacheWidth: 76,
                      cacheHeight: 112,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 38,
                          height: 56,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.movie, size: 20),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.favorite, color: movieAccentColor, size: 20),
                ],
              ),
            ),
          );
        }).toList();
      },
      onSelected: onRemoveFavorite,
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
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Movie movie;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
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
                  cacheWidth: 180,
                  cacheHeight: 270,
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
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
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
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Hapus dari favorite' : 'Tambah favorite',
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.initialIsFavorite,
    required this.onToggleFavorite,
  });

  final Movie movie;
  final bool initialIsFavorite;
  final ValueChanged<Movie> onToggleFavorite;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onToggleFavorite(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moviePageBackgroundColor,
      appBar: AppBar(
        backgroundColor: movieAppBarColor,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Hapus dari favorite' : 'Tambah favorite',
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? movieAccentColor : null,
            ),
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
                widget.movie.imageUrl,
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
            widget.movie.title,
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
                widget.movie.releaseDate,
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
                widget.movie.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: movieAccentColor,
              foregroundColor: Colors.white,
            ),
            onPressed: _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(
              _isFavorite ? 'Hapus dari Favorite' : 'Tambah ke Favorite',
            ),
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
            widget.movie.description,
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
