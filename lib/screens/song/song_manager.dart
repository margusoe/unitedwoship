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

  String formatLyrics(String xmlString) {
    String result = xmlString.replaceAll('<chord>', '[');
    result = result.replaceAll('</chord>', ']');
    result = result.replaceAll('<verse>', '');
    result = result.replaceAll('</verse>', '\n\n');
    result = result.replaceAll('<chorus>', '');
    result = result.replaceAll('</chorus>', '\n\n');
    result = result.replaceAll('<br />', '\n');
    result = result.replaceAll('<prechorus>', '');
    result = result.replaceAll('</prechorus>', '\n\n');
    result = result.replaceAll('<bridge>', '');
    result = result.replaceAll('</bridge>', '\n\n');

    print(result);

    return result;
  }
}
