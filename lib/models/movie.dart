// Folder structure for CineTrack:
// lib/
//   models/
//   services/
//   repositories/
//   providers/
//   screens/
//   widgets/
//
// Creating the Movie model.

class Movie {
  final int id;
  final String title;
  final List<int> genreIds;
  final double rating;
  final String releaseDate;
  final String posterPath;
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
