import 'dart:async';
import '../models/movie.dart';

const List<Movie> _mockMovies = [
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

class MovieRepository {
  // Simulasi pengambilan data asynchronous (Future)
  Future<List<Movie>> getMovies() async {
    // Delay 2 detik untuk simulasi loading dari internet
    await Future.delayed(const Duration(seconds: 2));
    return _mockMovies;
  }

  // Simulasi data realtime yang terus mengalir (Stream)
  Stream<int> getActiveUsersCount() {
    // Menghasilkan angka acak setiap 3 detik untuk mensimulasikan viewers online
    return Stream.periodic(const Duration(seconds: 3), (count) {
      // Base viewers: 1500, fluktuasi
      return 1500 + (count * 12 % 300) - (count * 5 % 100);
    });
  }
}

