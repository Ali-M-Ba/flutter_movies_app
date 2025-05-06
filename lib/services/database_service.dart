import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

// DatabaseService manages all local SQLite database operations for movies and watchlist.
// Implements a singleton pattern to ensure a single database instance is used throughout the app.
// Provides methods to insert, update, query, and delete movies and watchlist entries.
class DatabaseService {
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // The underlying SQLite database instance
  Database? _db;

  // Returns the database instance, initializing it if necessary
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initializes the database, creating tables if they do not exist
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create movies table for caching movie data
        await db.execute('''
          CREATE TABLE movies(
            id INTEGER PRIMARY KEY,
            title TEXT,
            genre_ids TEXT,
            rating REAL,
            release_date TEXT,
            poster_path TEXT,
            overview TEXT
          )
        ''');
        // Create watchlist table for user-saved movies
        await db.execute('''
          CREATE TABLE watchlist(
            id INTEGER PRIMARY KEY,
            title TEXT,
            genre_ids TEXT,
            rating REAL,
            release_date TEXT,
            poster_path TEXT,
            overview TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertOrUpdateMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  Future<void> clearMovies() async {
    final db = await database;
    await db.delete('movies');
  }

  Future<void> addToWatchlist(Movie movie) async {
    final db = await database;
    await db.insert(
      'watchlist',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFromWatchlist(int movieId) async {
    final db = await database;
    await db.delete('watchlist', where: 'id = ?', whereArgs: [movieId]);
  }

  Future<List<Movie>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('watchlist');
    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  Future<bool> isInWatchlist(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watchlist',
      where: 'id = ?',
      whereArgs: [movieId],
    );
    return maps.isNotEmpty;
  }

  // Gets a single movie by its ID from the local cache (movies table)
  Future<Movie?> getMovieById(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [movieId],
    );
    if (maps.isNotEmpty) {
      return Movie.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
