class FavoriteState {
  final Set<String> favoriteMovieTitles;
  
  FavoriteState(this.favoriteMovieTitles);

  bool isFavorite(String title) => favoriteMovieTitles.contains(title);
}
