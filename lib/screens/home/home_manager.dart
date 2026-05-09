import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';

class HomeManager {
  final SongDatabase _lyricsDatabase = getIt<SongDatabase>();
  final songListNotifier = ValueNotifier<List<Song>>([]);

  Future<void> init() async {
    final songs = await _lyricsDatabase.getAllSongs();
    songListNotifier.value = songs;
  }

  Future<void> deleteSong(String songId) async {
    await _lyricsDatabase.deleteSong(songId);
    init();
  }
}
