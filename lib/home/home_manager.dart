import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class HomeManager {
  final SongDatabase _lyricsDatabase = getIt<SongDatabase>();
  final songListNotifier = ValueNotifier<List<SongModel>>([]);
  Future<void> init() async {
    final songs = await _lyricsDatabase.getAllSongs();
    songListNotifier.value = songs;
  }
}
