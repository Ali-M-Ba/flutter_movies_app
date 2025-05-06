import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/database_service.dart';

// MovieRepository acts as an abstraction layer between the UI/providers and data sources (API & local DB).
// It decides whether to fetch data from the network (TMDBService) or local cache (DatabaseService).
// This pattern makes it easy to swap or combine data sources in the future.
class MovieRepository {
  final TMDBService _tmdbService = TMDBService();
  final DatabaseService _dbService = DatabaseService();

  // Fetch trending movies from TMDB and cache them locally.
  Future<List<Movie>> fetchTrendingMovies() async {
    final movies = await _tmdbService.fetchTrendingMovies();
    // Cache movies in local database for offline access
    for (final movie in movies) {
      await _dbService.insertOrUpdateMovie(movie);
    }
    return movies;
  }

  // Fetch movie details from TMDB by ID
  Future<Movie> getMovieDetails(int movieId) async {
    return await _tmdbService.fetchMovieDetails(movieId);
  }

  // Search for movies using TMDB API
  Future<List<Movie>> searchMovies(String query) async {
    return await _tmdbService.searchMovies(query);
  }

  // Rates a movie by delegating to the TMDBService
  Future<bool> rateMovie(int movieId, double rating) async {
    return await _tmdbService.rateMovie(movieId, rating);
  }

  // Get trending movies from local cache (used for offline mode)
  Future<List<Movie>> getCachedTrendingMovies() async {
    return await _dbService.getAllMovies();
  }

  // Gets a detailed cached movie by its ID from the local database. Returns null if not found.
  Future<Movie?> getCachedMovieDetails(int movieId) async {
    return await _dbService.getMovieById(movieId);
  }
}
