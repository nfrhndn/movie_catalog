import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';

const String _favoriteMovieIdsKey = 'favorite_movie_ids';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({Future<SharedPreferences>? preferences})
    : _preferences = preferences ?? SharedPreferences.getInstance(),
      super(FavoriteState({})) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  final Future<SharedPreferences> _preferences;

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final preferences = await _preferences;
    final favoriteMovieIds =
        preferences.getStringList(_favoriteMovieIdsKey)?.toSet() ?? {};

    emit(FavoriteState(favoriteMovieIds));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final currentFavorites = Set<String>.from(state.favoriteMovieIds);

    if (currentFavorites.contains(event.movie.id)) {
      currentFavorites.remove(event.movie.id);
    } else {
      currentFavorites.add(event.movie.id);
    }

    final preferences = await _preferences;
    await preferences.setStringList(
      _favoriteMovieIdsKey,
      currentFavorites.toList(),
    );

    emit(FavoriteState(currentFavorites));
  }
}
