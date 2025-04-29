import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import 'movie_details_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.watchlist.isEmpty) {
            return const Center(child: Text('Your watchlist is empty.'));
          }
          return ListView.builder(
            itemCount: provider.watchlist.length,
            itemBuilder: (context, index) {
              final movie = provider.watchlist[index];
              return ListTile(
                leading:
                    movie.posterPath.isNotEmpty
                        ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          width: 50,
                          fit: BoxFit.cover,
                        )
                        : Container(width: 50, color: Colors.grey),
                title: Text(movie.title),
                subtitle: Text('Release: \\${movie.releaseDate}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    provider.removeFromWatchlist(movie.id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MovieDetailsScreen(movieId: movie.id),
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
