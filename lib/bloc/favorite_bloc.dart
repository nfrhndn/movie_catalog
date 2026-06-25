import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteState({})) {
    on<ToggleFavoriteEvent>((event, emit) {
      // Copy the current set to mutate it
      final currentFavorites = Set<String>.from(state.favoriteMovieTitles);
      
      if (currentFavorites.contains(event.movie.title)) {
        currentFavorites.remove(event.movie.title);
      } else {
        currentFavorites.add(event.movie.title);
      }
      
      // Emit new state
      emit(FavoriteState(currentFavorites));
    });
  }
}
