class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.description,
    required this.imageUrl,
    required this.bannerUrl,
    required this.director,
    required this.producer,
    required this.runningTime,
  });

  final String id;
  final String title;
  final String releaseDate;
  final double rating;
  final String description;
  final String imageUrl;
  final String bannerUrl;
  final String director;
  final String producer;
  final String runningTime;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: _asString(json['id']),
      title: _asString(json['title']),
      releaseDate: _asString(json['release_date']),
      rating: _parseRating(json['rt_score']),
      description: _asString(json['description']),
      imageUrl: _asString(json['image']),
      bannerUrl: _asString(json['movie_banner']),
      director: _asString(json['director']),
      producer: _asString(json['producer']),
      runningTime: _asString(json['running_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'rt_score': (rating * 10).toStringAsFixed(0),
      'description': description,
      'image': imageUrl,
      'movie_banner': bannerUrl,
      'director': director,
      'producer': producer,
      'running_time': runningTime,
    };
  }
}

String _asString(Object? value) {
  return value?.toString() ?? '';
}

double _parseRating(Object? value) {
  final score = double.tryParse(_asString(value)) ?? 0;
  return score / 10;
}
