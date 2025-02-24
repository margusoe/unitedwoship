import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/infrastructure/in_app_storage.dart';
import 'package:magtaalhundetgel/infrastructure/service_locator.dart';
import 'package:magtaalhundetgel/infrastructure/user_settings.dart';

class SongManager {
  final lyricsNotifier = ValueNotifier<SongModel?>(null);
  final db = getIt<SongDatabase>();
  double fontSize = 17;

  Future<void> init(int songId) async {
    fontSize = getIt<UserSettings>().getFontSize();
    final lyrics = await db.getSong(songId);
    lyricsNotifier.value = lyrics;
  }
}
