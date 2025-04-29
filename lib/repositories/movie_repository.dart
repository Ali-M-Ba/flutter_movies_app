import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/database_service.dart';

class MovieRepository {
  final TMDBService _tmdbService = TMDBService();
  final DatabaseService _dbService = DatabaseService();

  Future<List<Movie>> getTrendingMovies({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        final movies = await _tmdbService.fetchTrendingMovies();
        await _dbService.clearMovies();
        for (var movie in movies) {
          await _dbService.insertOrUpdateMovie(movie);
        }
        return movies;
      } else {
        final localMovies = await _dbService.getAllMovies();
        if (localMovies.isNotEmpty) {
          return localMovies;
        } else {
          final movies = await _tmdbService.fetchTrendingMovies();
          for (var movie in movies) {
            await _dbService.insertOrUpdateMovie(movie);
          }
          return movies;
        }
      }
    } catch (e) {
      // On error, fallback to local data if available
      final localMovies = await _dbService.getAllMovies();
      if (localMovies.isNotEmpty) {
        return localMovies;
      }
      rethrow;
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      return await _tmdbService.fetchMovieDetails(movieId);
    } catch (e) {
      // Optionally, fetch from local DB if details are cached
      rethrow;
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _tmdbService.searchMovies(query);
    } catch (e) {
      return [];
    }
  }
}
