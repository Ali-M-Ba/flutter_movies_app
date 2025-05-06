import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import 'movie_details_screen.dart';

// WatchlistScreen displays the user's saved watchlist.
// Uses WatchlistProvider to get the current watchlist and updates when changed.
// Tapping a movie navigates to MovieDetailsScreen.
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          final watchlist = provider.watchlist;
          if (watchlist.isEmpty) {
            return const Center(child: Text('Your watchlist is empty.'));
          }
          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final movie = watchlist[index];
              return ListTile(
                leading:
                    movie.posterPath.isNotEmpty
                        ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 50,
                                height: 75,
                                color: Colors.grey,
                              ),
                        )
                        : Container(width: 50, height: 75, color: Colors.grey),
                title: Text(
                  movie.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('⭐ Rating: ${movie.rating.toStringAsFixed(1)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
