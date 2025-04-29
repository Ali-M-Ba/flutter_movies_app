import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
}
