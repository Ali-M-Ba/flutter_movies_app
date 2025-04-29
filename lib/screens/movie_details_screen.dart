import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/watchlist_provider.dart';
import '../repositories/movie_repository.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: FutureBuilder<Movie>(
        future: MovieRepository().getMovieDetails(movieId),
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
                      Text('Release Date: \\${movie.releaseDate}'),
                      const SizedBox(height: 8),
                      Text('Rating: \\${movie.rating}'),
                      const SizedBox(height: 16),
                      Text(movie.overview),
                      const SizedBox(height: 24),
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
