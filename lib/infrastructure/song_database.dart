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
      version: 3, // Bumped for PocketBase schema
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
        $columnUpdated TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $tableLyrics");
    await _createDB(db, newVersion);
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

  // Get a single song (Changed ID to String)
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

  // Get All Songs
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final result = await db.query(tableLyrics, orderBy: columnTitle);
    return result.map((map) => Song.fromDb(map)).toList();
  }

  // Get latest updated date (Used for offline sync later)
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

  Future close() async {
    final db = await database;
    db.close();
  }
}
