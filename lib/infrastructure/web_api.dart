import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'service_locator.dart';
import 'song_database.dart';
import 'song.dart';

class WebApi {
  List<Song> songs = [];

  // Access via GetIt
  final db = getIt<SongDatabase>();

  Song getSong(int songId) {
    // Try to find in memory, otherwise you might need to fetch from DB
    return songs.firstWhere((song) => song.id == songId);
  }

  Future<void> loadSongs() async {
    // 1. Initialize DB
    await db.init();

    // 2. Check if empty
    if (await db.isDbEmpty()) {
      debugPrint("Database empty. Loading from Assets...");

      final String jsonString = await rootBundle.loadString('assets/dbmn.json');
      final Map<String, dynamic> parsedJson = json.decode(jsonString);
      final List<dynamic> songListJson = parsedJson['data'];

      // Parse JSON
      List<Song> parsedSongs =
          songListJson.map((json) => Song.fromJson(json)).toList();

      // Save to SQLite
      await db.insertBatch(parsedSongs);
    }

    // 3. Load from DB into Memory
    songs = await db.getAllSongs();
    debugPrint(songs.where((song) {
      return song.title.startsWith("Praise");
    }).first.toString());
    debugPrint("Loaded ${songs.length} songs from database.");
  }
}
