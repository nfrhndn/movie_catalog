import '../models/movie.dart';

abstract class FavoriteEvent {}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final Movie movie;
  ToggleFavoriteEvent(this.movie);
}
