class Movie {
  const Movie({
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  final String title;
  final String releaseDate;
  final double rating;
  final String description;
  final String imageUrl;
}
