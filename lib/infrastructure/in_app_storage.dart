import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SongDatabase {
  late Database _database;

  // Database name
  static const String _dbName = 'lyrics.db';

  // Table name
  static const String tableLyrics = 'lyrics';

  // Column names
  static const String columnSongId = 'song_id';
  static const String columnSongName = 'song_name';
  static const String columnComposer = 'composer';
  static const String columnLyricAuthor = 'lyric_author';
  static const String columnOriginalKey = 'original_key';
  static const String columnDateAdded = 'date_added';
  static const String columnLyrics = 'lyrics';

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    _database = await openDatabase(
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
        $columnLyrics TEXT NOT NULL,
        $columnDateAdded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<int> createSong(SongModel lyrics) async {
    return await _database.insert(tableLyrics, lyrics.toJson());
  }

  Future<SongModel?> getSong(int songId) async {
    final maps = await _database.query(
      tableLyrics,
      columns: [
        columnSongId,
        columnSongName,
        columnComposer,
        columnLyricAuthor,
        columnOriginalKey,
        columnLyrics,
        columnDateAdded
      ],
      where: '$columnSongId = ?',
      whereArgs: [songId],
    );

    if (maps.isNotEmpty) {
      return SongModel.fromJson(maps.first);
    }
    return null;
  }

  Future<List<(int id, String title)>> getAllSongs() async {
    final result = await _database.query(tableLyrics, orderBy: '$columnDateAdded DESC');
    return result.map((map) => (map[columnSongId] as int, map[columnSongName] as String)).toList();
  }

  Future<int> updateSong(SongModel lyrics) async {
    return _database.update(
      tableLyrics,
      lyrics.toJson(),
      where: '$columnSongId = ?',
      whereArgs: [lyrics.songId],
    );
  }

  Future<int> deleteSong(int songId) async {
    return await _database.delete(
      tableLyrics,
      where: '$columnSongId = ?',
      whereArgs: [songId],
    );
  }

  Future close() async {
    _database.close();
  }
}

class SongModel {
  final int? songId;
  final String title;
  final String composer;
  final String lyricAuthor;
  final String originalKey;
  final String lyrics;
  final DateTime dateAdded;

  SongModel({
    this.songId,
    required this.title,
    required this.composer,
    required this.lyricAuthor,
    required this.originalKey,
    required this.lyrics,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        SongDatabase.columnSongId: songId,
        SongDatabase.columnSongName: title,
        SongDatabase.columnComposer: composer,
        SongDatabase.columnLyricAuthor: lyricAuthor,
        SongDatabase.columnOriginalKey: originalKey,
        SongDatabase.columnLyrics: lyrics,
        SongDatabase.columnDateAdded: dateAdded.toIso8601String(),
      };

  static SongModel fromJson(Map<String, dynamic> json) => SongModel(
        songId: json[SongDatabase.columnSongId] as int?,
        title: json[SongDatabase.columnSongName] as String,
        composer: json[SongDatabase.columnComposer] as String,
        lyricAuthor: json[SongDatabase.columnLyricAuthor] as String,
        originalKey: json[SongDatabase.columnOriginalKey] as String,
        lyrics: json[SongDatabase.columnLyrics] as String,
        dateAdded: DateTime.parse(json[SongDatabase.columnDateAdded] as String),
      );

  SongModel copy({
    int? songId,
    String? songName,
    String? composer,
    String? lyricAuthor,
    String? originalKey,
    String? lyrics,
    DateTime? dateAdded,
  }) =>
      SongModel(
        songId: songId ?? this.songId,
        title: songName ?? this.title,
        composer: composer ?? this.composer,
        lyricAuthor: lyricAuthor ?? this.lyricAuthor,
        originalKey: originalKey ?? this.originalKey,
        lyrics: lyrics ?? this.lyrics,
        dateAdded: dateAdded ?? this.dateAdded,
      );
}
