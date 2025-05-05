import 'package:flutter/material.dart';
import '../repositories/movie_repository.dart';
import '../models/movie.dart';
import '../screens/movie_details_screen.dart';

// HomeScreen displays a list of trending movies.
// It fetches data from MovieRepository and shows loading/error states.
// Tapping a movie navigates to the MovieDetailsScreen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _trendingMovies;

  @override
  void initState() {
    super.initState();
    // Fetch trending movies when the screen is initialized
    _trendingMovies = MovieRepository().fetchTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Movies')),
      body: FutureBuilder<List<Movie>>(
        future: _trendingMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
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
                subtitle: Text('Rating: \\${movie.rating}'),
                onTap: () {
                  // Navigate to details screen with selected movie ID
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
