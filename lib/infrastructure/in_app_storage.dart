import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LyricsDatabase {
  static final LyricsDatabase instance = LyricsDatabase._init();
  static Database? _database;

  // Database name
  static const String dbName = 'lyrics.db';

  // Table name
  static const String tableLyrics = 'lyrics';

  // Column names
  static const String columnSongId = 'song_id';
  static const String columnSongName = 'song_name';
  static const String columnComposer = 'composer';
  static const String columnLyricAuthor = 'lyric_author';
  static const String columnOriginalKey = 'original_key';
  static const String columnDateAdded = 'date_added';

  LyricsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableLyrics (
        $columnSongId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnSongName TEXT NOT NULL,
        $columnComposer TEXT NOT NULL,
        $columnLyricAuthor TEXT NOT NULL,
        $columnOriginalKey TEXT NOT NULL,
        $columnDateAdded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<int> createLyrics(LyricsModel lyrics) async {
    final db = await instance.database;
    return await db.insert(tableLyrics, lyrics.toJson());
  }

  Future<LyricsModel?> readLyrics(int songId) async {
    final db = await instance.database;
    final maps = await db.query(
      tableLyrics,
      columns: [
        columnSongId,
        columnSongName,
        columnComposer,
        columnLyricAuthor,
        columnOriginalKey,
        columnDateAdded
      ],
      where: '$columnSongId = ?',
      whereArgs: [songId],
    );

    if (maps.isNotEmpty) {
      return LyricsModel.fromJson(maps.first);
    }
    return null;
  }

  Future<List<LyricsModel>> readAllLyrics() async {
    final db = await instance.database;
    final result =
        await db.query(tableLyrics, orderBy: '$columnDateAdded DESC');
    return result.map((json) => LyricsModel.fromJson(json)).toList();
  }

  Future<int> updateLyrics(LyricsModel lyrics) async {
    final db = await instance.database;
    return db.update(
      tableLyrics,
      lyrics.toJson(),
      where: '$columnSongId = ?',
      whereArgs: [lyrics.songId],
    );
  }

  Future<int> deleteLyrics(int songId) async {
    final db = await instance.database;
    return await db.delete(
      tableLyrics,
      where: '$columnSongId = ?',
      whereArgs: [songId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class LyricsModel {
  final int? songId;
  final String songName;
  final String composer;
  final String lyricAuthor;
  final String originalKey;
  final DateTime dateAdded;

  LyricsModel({
    this.songId,
    required this.songName,
    required this.composer,
    required this.lyricAuthor,
    required this.originalKey,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        LyricsDatabase.columnSongId: songId,
        LyricsDatabase.columnSongName: songName,
        LyricsDatabase.columnComposer: composer,
        LyricsDatabase.columnLyricAuthor: lyricAuthor,
        LyricsDatabase.columnOriginalKey: originalKey,
        LyricsDatabase.columnDateAdded: dateAdded.toIso8601String(),
      };

  static LyricsModel fromJson(Map<String, dynamic> json) => LyricsModel(
        songId: json[LyricsDatabase.columnSongId] as int?,
        songName: json[LyricsDatabase.columnSongName] as String,
        composer: json[LyricsDatabase.columnComposer] as String,
        lyricAuthor: json[LyricsDatabase.columnLyricAuthor] as String,
        originalKey: json[LyricsDatabase.columnOriginalKey] as String,
        dateAdded:
            DateTime.parse(json[LyricsDatabase.columnDateAdded] as String),
      );

  LyricsModel copy({
    int? songId,
    String? songName,
    String? composer,
    String? lyricAuthor,
    String? originalKey,
    DateTime? dateAdded,
  }) =>
      LyricsModel(
        songId: songId ?? this.songId,
        songName: songName ?? this.songName,
        composer: composer ?? this.composer,
        lyricAuthor: lyricAuthor ?? this.lyricAuthor,
        originalKey: originalKey ?? this.originalKey,
        dateAdded: dateAdded ?? this.dateAdded,
      );
}
