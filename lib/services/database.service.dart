import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'leaderboard.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE leaderboard(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player TEXT NOT NULL,
            category TEXT NOT NULL,
            score INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  /// Add a new user to the leaderboard
  Future<void> addUser(String player, String category) async {
    final db = await database;

    final existingUser = await db.query(
      'leaderboard',
      where: 'player = ? AND category = ?',
      whereArgs: [player, category],
    );

    if (existingUser.isEmpty) {
      await db.insert(
        'leaderboard',
        {'player': player, 'category': category, 'score': 0},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Update the user's score in the leaderboard
  Future<void> updateScore(String player, String category, int score) async {
    final db = await database;

    await db.update(
      'leaderboard',
      {'score': score},
      where: 'player = ? AND category = ?',
      whereArgs: [player, category],
    );
  }

  /// Get the top scores from the leaderboard
  Future<List<Map<String, dynamic>>> getTopScores({int limit = 10}) async {
    final db = await database;

    return await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: limit,
    );
  }
}
