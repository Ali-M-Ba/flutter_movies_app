import 'package:flutter/material.dart';
import '../repositories/movie_repository.dart';
import '../models/movie.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Movie>>? _searchResults;

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
            Expanded(
              child:
                  _searchResults == null
                      ? const Center(
                        child: Text('Search for movies by title or genre.'),
                      )
                      : FutureBuilder<List<Movie>>(
                        future: _searchResults,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: \\${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No results found.'),
                            );
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
                                        : Container(
                                          width: 50,
                                          color: Colors.grey,
                                        ),
                                title: Text(movie.title),
                                subtitle: Text(
                                  'Release: \\${movie.releaseDate}',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MovieDetailsScreen(
                                            movieId: movie.id,
                                          ),
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
