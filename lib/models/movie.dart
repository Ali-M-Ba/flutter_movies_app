// Creating the Movie model.
// The Movie model represents a movie entity throughout the app.
// It provides methods for JSON serialization/deserialization and database mapping.
class Movie {
  // Unique identifier for the movie
  final int id;
  // Movie title
  final String title;
  // List of genre IDs associated with the movie
  final List<int> genreIds;
  // Average rating (vote_average from TMDB)
  final double rating;
  // Release date as a string
  final String releaseDate;
  // Path to the movie poster image
  final String posterPath;
  // Overview/description of the movie
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.genreIds,
    required this.rating,
    required this.releaseDate,
    required this.posterPath,
    required this.overview,
  });

  // Factory constructor to create a Movie from TMDB API JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
    );
  }

  // Converts the Movie object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre_ids': genreIds.join(','),
      'rating': rating,
      'release_date': releaseDate,
      'poster_path': posterPath,
      'overview': overview,
    };
  }

  // Factory constructor to create a Movie from a database map
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      genreIds:
          (map['genre_ids'] as String)
              .split(',')
              .where((e) => e.isNotEmpty)
              .map(int.parse)
              .toList(),
      rating: (map['rating'] ?? 0).toDouble(),
      releaseDate: map['release_date'] ?? '',
      posterPath: map['poster_path'] ?? '',
      overview: map['overview'] ?? '',
    );
  }
}
