import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(this._movieRepository) : super(MovieInitial()) {
    on<LoadMoviesEvent>(_onLoadMovies);
  }

  final MovieRepository _movieRepository;

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    try {
      final result = await _movieRepository.getMovies();
      emit(MovieLoaded(movies: result.movies, isFromCache: result.isFromCache));
    } catch (error) {
      emit(MovieError(error.toString()));
    }
  }
}
