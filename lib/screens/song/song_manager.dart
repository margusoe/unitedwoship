import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

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
