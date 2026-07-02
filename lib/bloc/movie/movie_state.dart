import '../../models/movie.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  MovieLoaded({required this.movies, required this.isFromCache});

  final List<Movie> movies;
  final bool isFromCache;
}

class MovieError extends MovieState {
  MovieError(this.message);

  final String message;
}
