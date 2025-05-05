import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/database_service.dart';

// WatchlistProvider manages the user's watchlist state using the Provider package.
// It exposes methods to add, remove, and check movies in the watchlist, and notifies listeners on changes.
// Data is persisted using DatabaseService, so the watchlist is retained across app launches.
class WatchlistProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Movie> _watchlist = [];

  // Returns the current watchlist
  List<Movie> get watchlist => _watchlist;

  // Loads the watchlist from the local database
  Future<void> loadWatchlist() async {
    _watchlist = await _dbService.getWatchlist();
    notifyListeners();
  }

  // Adds a movie to the watchlist and updates listeners
  Future<void> addToWatchlist(Movie movie) async {
    await _dbService.addToWatchlist(movie);
    await loadWatchlist();
  }

  // Removes a movie from the watchlist and updates listeners
  Future<void> removeFromWatchlist(int movieId) async {
    await _dbService.removeFromWatchlist(movieId);
    await loadWatchlist();
  }

  // Checks if a movie is in the watchlist
  Future<bool> isInWatchlist(int movieId) async {
    return await _dbService.isInWatchlist(movieId);
  }
}
