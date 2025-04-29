import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/database_service.dart';

class WatchlistProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Movie> _watchlist = [];
  bool _isLoading = false;

  List<Movie> get watchlist => _watchlist;
  bool get isLoading => _isLoading;

  Future<void> loadWatchlist() async {
    _isLoading = true;
    notifyListeners();
    _watchlist = await _dbService.getWatchlist();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToWatchlist(Movie movie) async {
    await _dbService.addToWatchlist(movie);
    await loadWatchlist();
  }

  Future<void> removeFromWatchlist(int movieId) async {
    await _dbService.removeFromWatchlist(movieId);
    await loadWatchlist();
  }

  Future<bool> isInWatchlist(int movieId) async {
    return await _dbService.isInWatchlist(movieId);
  }
}
