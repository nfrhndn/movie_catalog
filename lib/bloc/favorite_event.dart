import '../models/movie.dart';

abstract class FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final Movie movie;
  ToggleFavoriteEvent(this.movie);
}
