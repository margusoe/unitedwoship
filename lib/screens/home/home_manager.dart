import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/infrastructure/in_app_storage.dart';
import 'package:magtaalhundetgel/infrastructure/service_locator.dart';

class HomeManager {
  final SongDatabase _lyricsDatabase = getIt<SongDatabase>();
  final songListNotifier = ValueNotifier<List<(int, String)>>([]);
  Future<void> init() async {
    final songs = await _lyricsDatabase.getAllSongs();
    songListNotifier.value = songs;
  }

  Future<void> deleteSong(int songId) async {
    await _lyricsDatabase.deleteSong(songId);
    init();
  }
}
