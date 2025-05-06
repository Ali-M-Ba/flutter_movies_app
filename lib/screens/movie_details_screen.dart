import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../providers/watchlist_provider.dart';
import '../repositories/movie_repository.dart';

// MovieDetailsScreen shows detailed information for a selected movie.
// Fetches movie details from MovieRepository and displays them.
// Integrates with WatchlistProvider to allow adding/removing the movie from the watchlist.
class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  double _userRating = 3.0;
  bool _isSubmitting = false;
  String? _submitMessage;
  late Future<Movie> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = _loadMovieWithFallback(widget.movieId);
  }

  Future<Movie> _loadMovieWithFallback(int movieId) async {
    try {
      // Try to fetch from network
      return await MovieRepository().getMovieDetails(movieId);
    } catch (e) {
      // On error (e.g., no internet), try to fetch from cache
      final cached = await MovieRepository().getCachedMovieDetails(movieId);
      if (cached != null) {
        return cached;
      } else {
        // Rethrow if not found in cache
        throw Exception('Movie not found (offline and not cached)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: FutureBuilder<Movie>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Movie not found.'));
          }
          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                movie.posterPath.isNotEmpty
                    ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 400,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Container(height: 400, color: Colors.grey),
                    )
                    : Container(height: 400, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('📅 Release Date: ${movie.releaseDate}'),
                      const SizedBox(height: 8),
                      Text('⭐ Rating: ${movie.rating.toStringAsFixed(1)}'),
                      const SizedBox(height: 16),
                      Text('🔎 Overview: ${movie.overview}'),
                      const SizedBox(height: 24),
                      // Watchlist button uses Provider and FutureBuilder to check state
                      Consumer<WatchlistProvider>(
                        builder: (context, provider, child) {
                          return FutureBuilder<bool>(
                            future: provider.isInWatchlist(movie.id),
                            builder: (context, watchlistSnapshot) {
                              final isInWatchlist =
                                  watchlistSnapshot.data ?? false;
                              return ElevatedButton.icon(
                                icon: Icon(
                                  isInWatchlist
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                label: Text(
                                  isInWatchlist
                                      ? 'Remove from Watchlist'
                                      : 'Add to Watchlist',
                                ),
                                onPressed: () {
                                  if (isInWatchlist) {
                                    provider.removeFromWatchlist(movie.id);
                                  } else {
                                    provider.addToWatchlist(movie);
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '🤩 Rate this movie:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: _userRating,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 60, // Make stars smaller
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        itemBuilder:
                            (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _userRating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isSubmitting = true;
                                _submitMessage = null;
                              });
                              try {
                                final success = await MovieRepository()
                                    .rateMovie(movie.id, _userRating);
                                setState(() {
                                  _submitMessage =
                                      success
                                          ? 'Thank you for rating!'
                                          : 'Failed to submit rating.';
                                });
                              } catch (e) {
                                setState(() {
                                  _submitMessage =
                                      'Error: check your internet connection.';
                                });
                              } finally {
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            },
                            child: const Text('Submit Rating'),
                          ),
                      if (_submitMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _submitMessage!,
                          style: TextStyle(
                            color:
                                _submitMessage == 'Thank you for rating!'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
