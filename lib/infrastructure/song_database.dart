import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'song.dart'; // Import your Song class

class SongDatabase {
  Database? _database;

  // Database name
  static const String _dbName = 'lyrics.db';

  // Table name
  static const String tableLyrics = 'lyrics';

  // Column names
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnKey = 'song_key';
  static const String columnXml = 'song_xml';
  static const String columnAuthor = 'author';
  static const String columnYoutube = 'youtube_link';

  // Get database instance (ensures init is called)
  Future<Database> get database async {
    if (_database != null) return _database!;
    await init();
    return _database!;
  }

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);
    _database = await openDatabase(
      path,
      version: 2, // Bumped version since schema changed
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableLyrics (
        $columnId INTEGER PRIMARY KEY, 
        $columnTitle TEXT NOT NULL,
        $columnKey TEXT,
        $columnXml TEXT,
        $columnAuthor TEXT,
        $columnYoutube TEXT
      )
    ''');
  }

  // Handle schema changes if users have the old app version
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 2) {
    await db.execute("DROP TABLE IF EXISTS $tableLyrics");
    await _createDB(db, newVersion);
    // }
  }

  // --- Actions ---

  // Check if we need to load JSON
  Future<bool> isDbEmpty() async {
    final db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableLyrics'));
    return count == 0;
  }

  // Bulk Insert (Fast)
  Future<void> insertBatch(List<Song> songs) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var song in songs) {
        batch.insert(
          tableLyrics,
          song.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // Get a single song
  Future<Song?> getSong(int id) async {
    final db = await database;
    final maps = await db.query(
      tableLyrics,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Song.fromDb(maps.first);
    }
    return null;
  }

  // Get All Songs
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final result = await db.query(tableLyrics, orderBy: columnTitle);
    return result.map((map) => Song.fromDb(map)).toList();
  }

  // Search
  Future<List<Song>> searchSongs(String query) async {
    final db = await database;
    final result = await db.query(tableLyrics,
        where: '$columnTitle LIKE ?', whereArgs: ['%$query%']);
    return result.map((map) => Song.fromDb(map)).toList();
  }

  /// Deletes a song by its ID.
  /// Returns the number of rows affected (should be 1 if successful).
  Future<int> deleteSong(int id) async {
    final db = await database;

    return await db.delete(
      tableLyrics,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
