import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart'; // Add this import
import 'song.dart';

class SongDatabase {
  Database? _database;

  static const String _dbName = 'lyrics.db';

  // Table Names
  static const String tableLyrics = 'lyrics';
  static const String tableSetlists = 'setlists';
  static const String tableSetlistItems = 'setlist_items';

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
  static const String columnIsFavorite = 'is_favorite';

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
      version: 5, // BUMPED TO 5 for setlists
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Create Songs Table
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

    // 2. Create Setlists Table
    await db.execute('''
      CREATE TABLE $tableSetlists (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        scheduled_date TEXT NOT NULL,
        live_current_item_id TEXT,
        owner TEXT NOT NULL
      )
    ''');

    // 3. Create Setlist Items Table
    await db.execute('''
      CREATE TABLE $tableSetlistItems (
        id TEXT PRIMARY KEY,
        setlist_id TEXT NOT NULL,
        song_id TEXT NOT NULL,
        selected_key TEXT NOT NULL,
        capo INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (setlist_id) REFERENCES $tableSetlists (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      // If upgrading from older versions, just drop and recreate for safety
      // (in a production app with thousands of users, we'd do a safe migration,
      // but for this stage of development, dropping is fine)
      await db.execute("DROP TABLE IF EXISTS $tableSetlistItems");
      await db.execute("DROP TABLE IF EXISTS $tableSetlists");
      await db.execute("DROP TABLE IF EXISTS $tableLyrics");
      await _createDB(db, newVersion);
    }
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableSetlistItems);
    await db.delete(tableSetlists);
    await db.delete(tableLyrics);
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

  // --- NEW: SETLIST METHODS ---

  Future<void> insertSetlistsBatch(List<Setlist> setlists) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var s in setlists) {
        batch.insert(tableSetlists, s.toDbMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> insertSetlistItemsBatch(List<SetlistItem> items) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var item in items) {
        batch.insert(tableSetlistItems, item.toDbMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<Setlist>> getAllSetlists() async {
    final db = await database;
    final result =
        await db.query(tableSetlists, orderBy: 'scheduled_date DESC');
    return result.map((map) => Setlist.fromDb(map)).toList();
  }

  Future<List<SetlistItem>> getSetlistItems(String setlistId) async {
    final db = await database;
    final result = await db.query(
      tableSetlistItems,
      where: 'setlist_id = ?',
      whereArgs: [setlistId],
      orderBy: 'sort_order ASC',
    );
    return result.map((map) => SetlistItem.fromDb(map)).toList();
  }

  Future<void> deleteLocalSetlist(String id) async {
    final db = await database;
    await db
        .delete(tableSetlistItems, where: 'setlist_id = ?', whereArgs: [id]);
    await db.delete(tableSetlists, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
