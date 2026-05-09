// lib/infrastructure/song_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'song.dart';

class SongDatabase {
  Database? _database;

  static const String _dbName = 'lyrics.db';
  static const String tableLyrics = 'lyrics';

  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnAuthors = 'authors';
  static const String columnOriginalKey = 'original_key';
  static const String columnLyrics = 'lyrics';
  static const String columnMediaLink = 'media_link';
  static const String columnTempoBpm = 'tempo_bpm';
  static const String columnTimeSignature = 'time_signature';
  static const String columnThemes = 'themes';
  static const String columnApprovalStatus = 'approval_status';
  static const String columnUpdated = 'updated';
  static const String columnIsFavorite = 'is_favorite'; // Added

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
      version: 4, // Bumped for is_favorite column
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableLyrics (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAuthors TEXT,
        $columnOriginalKey TEXT,
        $columnLyrics TEXT,
        $columnMediaLink TEXT,
        $columnTempoBpm INTEGER,
        $columnTimeSignature TEXT,
        $columnThemes TEXT,
        $columnApprovalStatus TEXT,
        $columnUpdated TEXT,
        $columnIsFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      try {
        await db.execute(
            "ALTER TABLE $tableLyrics ADD COLUMN $columnIsFavorite INTEGER DEFAULT 0");
      } catch (_) {
        await db.execute("DROP TABLE IF EXISTS $tableLyrics");
        await _createDB(db, newVersion);
      }
    } else {
      await db.execute("DROP TABLE IF EXISTS $tableLyrics");
      await _createDB(db, newVersion);
    }
  }

  // Bulk Insert (Preserves existing favorites)
  Future<void> insertBatch(List<Song> songs) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var song in songs) {
        // Retrieve local favorite status so a PB sync doesn't overwrite it
        final existing = await txn.query(
          tableLyrics,
          columns: [columnIsFavorite],
          where: '$columnId = ?',
          whereArgs: [song.id],
        );

        int isFav = 0;
        if (existing.isNotEmpty && existing.first[columnIsFavorite] != null) {
          isFav = existing.first[columnIsFavorite] as int;
        }

        final map = song.toDbMap();
        map[columnIsFavorite] = isFav; // Override with local value

        batch.insert(
          tableLyrics,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<Song?> getSong(String id) async {
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

  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final result = await db.query(tableLyrics, orderBy: columnTitle);
    return result.map((map) => Song.fromDb(map)).toList();
  }

  // --- NEW: Favorite Methods ---
  Future<List<Song>> getFavoriteSongs() async {
    final db = await database;
    final result = await db.query(
      tableLyrics,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
      orderBy: columnTitle,
    );
    return result.map((map) => Song.fromDb(map)).toList();
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    final db = await database;
    await db.update(
      tableLyrics,
      {columnIsFavorite: isFavorite ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<DateTime?> getLastSyncDate() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT MAX($columnUpdated) as last_update FROM $tableLyrics');
    if (result.isNotEmpty && result.first['last_update'] != null) {
      return DateTime.parse(result.first['last_update'] as String);
    }
    return null;
  }

  Future<List<Song>> searchSongs(String query) async {
    final db = await database;
    final result = await db.query(tableLyrics,
        where: '$columnTitle LIKE ?', whereArgs: ['%$query%']);
    return result.map((map) => Song.fromDb(map)).toList();
  }

  Future<int> deleteSong(String id) async {
    final db = await database;
    return await db.delete(
      tableLyrics,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Add this inside SongDatabase class
  Future<void> clearAll() async {
    final db = await database;
    await db
        .delete(tableLyrics); // Deletes all rows, keeping the table structure
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
