import 'package:flutter/material.dart';
import '../repositories/movie_repository.dart';
import '../models/movie.dart';
import 'movie_details_screen.dart';

// SearchScreen allows users to search for movies by title or genre.
// Uses a TextField for input and displays search results in a list.
// Results are fetched from MovieRepository and tapping a result navigates to MovieDetailsScreen.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Movie>>? _searchResults;

  // Called when the user submits a search query
  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = MovieRepository().searchMovies(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter movie title or genre',
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Display search results if available
            if (_searchResults != null)
              Expanded(
                child: FutureBuilder<List<Movie>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: check your internet connection.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No results found.'));
                    }
                    final results = snapshot.data!;
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final movie = results[index];
                        return ListTile(
                          leading:
                              movie.posterPath.isNotEmpty
                                  ? Image.network(
                                    'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(width: 50, color: Colors.grey),
                          title: Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '⭐ Rating: ${movie.rating.toStringAsFixed(1)}',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        MovieDetailsScreen(movieId: movie.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
