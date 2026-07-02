class FavoriteState {
  FavoriteState(this.favoriteMovieIds);

  final Set<String> favoriteMovieIds;

  bool isFavorite(String movieId) => favoriteMovieIds.contains(movieId);
}
