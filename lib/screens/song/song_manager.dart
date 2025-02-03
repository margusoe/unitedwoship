import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class SongManager {
  final lyricsNotifier = ValueNotifier<SongModel?>(null);
  final db = getIt<SongDatabase>();

  Future<void> init(int songId) async {
    final lyrics = await db.getSong(songId);
    lyricsNotifier.value = lyrics;
  }
}
