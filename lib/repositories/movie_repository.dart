import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

const String _moviesCacheKey = 'cached_movies';
const String _filmsEndpoint = 'https://ghibliapi.dev/films';

class MovieResult {
  const MovieResult({required this.movies, required this.isFromCache});

  final List<Movie> movies;
  final bool isFromCache;
}

class MovieRepository {
  MovieRepository({Dio? dio, Future<SharedPreferences>? preferences})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ),
      _preferences = preferences ?? SharedPreferences.getInstance();

  final Dio _dio;
  final Future<SharedPreferences> _preferences;

  Future<MovieResult> getMovies() async {
    try {
      final response = await _dio.get<List<dynamic>>(_filmsEndpoint);
      final movies =
          response.data
              ?.whereType<Map<String, dynamic>>()
              .map(Movie.fromJson)
              .toList() ??
          [];

      if (movies.isEmpty) {
        throw const FormatException('Data film dari API kosong.');
      }

      await _saveMoviesToCache(movies);

      return MovieResult(movies: movies, isFromCache: false);
    } catch (_) {
      final cachedMovies = await _getMoviesFromCache();

      if (cachedMovies.isNotEmpty) {
        return MovieResult(movies: cachedMovies, isFromCache: true);
      }

      throw Exception(
        'Gagal mengambil data film. Periksa koneksi internet, lalu coba lagi.',
      );
    }
  }

  Stream<int> getActiveUsersCount() {
    return Stream.periodic(const Duration(seconds: 3), (count) {
      return 1500 + (count * 12 % 300) - (count * 5 % 100);
    });
  }

  Future<void> _saveMoviesToCache(List<Movie> movies) async {
    final preferences = await _preferences;
    final encodedMovies = jsonEncode(
      movies.map((movie) => movie.toJson()).toList(),
    );

    await preferences.setString(_moviesCacheKey, encodedMovies);
  }

  Future<List<Movie>> _getMoviesFromCache() async {
    final preferences = await _preferences;
    final cachedMovies = preferences.getString(_moviesCacheKey);

    if (cachedMovies == null || cachedMovies.isEmpty) {
      return [];
    }

    final decodedMovies = jsonDecode(cachedMovies);

    if (decodedMovies is! List) {
      return [];
    }

    return decodedMovies
        .whereType<Map<String, dynamic>>()
        .map(Movie.fromJson)
        .toList();
  }
}
