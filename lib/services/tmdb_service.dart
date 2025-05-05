import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

// Service class responsible for communicating with The Movie Database (TMDB) API.
// Handles fetching trending movies, movie details, and searching for movies.
// All methods return Movie model objects for use throughout the app.
class TMDBService {
  // TMDB API key
  static const String _apiKey = 'e94863fa505358b3679a5d0e48ae5a3a';
  // Base URL for TMDB API endpoints
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Fetches a list of trending movies for the week from TMDB.
  // Returns a list of Movie objects.
  Future<List<Movie>> fetchTrendingMovies() async {
    final url = Uri.parse('$_baseUrl/trending/movie/week?api_key=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      // Map each result to a Movie model instance
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // Fetches detailed information for a specific movie by its ID.
  // Returns a Movie object with full details.
  Future<Movie> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // Searches for movies matching the given query string.
  // Returns a list of Movie objects that match the search.
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  // Rates a movie using TMDB's API. Returns true if successful.
  Future<bool> rateMovie(int movieId, double rating) async {
    // Get a guest session ID
    final guestSessionUrl = Uri.parse('$_baseUrl/authentication/guest_session/new?api_key=$_apiKey');
    final guestSessionResponse = await http.get(guestSessionUrl);
    if (guestSessionResponse.statusCode != 200) {
      throw Exception('Failed to get guest session');
    }
    final guestSessionId = json.decode(guestSessionResponse.body)['guest_session_id'];

    // Send the rating
    final url = Uri.parse('$_baseUrl/movie/$movieId/rating?api_key=$_apiKey&guest_session_id=$guestSessionId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: json.encode({'value': rating}),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }
}
