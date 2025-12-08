import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class SongManager {
  final lyricsNotifier = ValueNotifier<SongModel?>(null);
  final db = getIt<SongDatabase>();

  Future<void> init(int songId) async {
    final lyrics = await db.getSong(songId);
    lyricsNotifier.value = lyrics;
  }

  String formatLyrics(String xmlString) {
    String result = xmlString.replaceAll('<chord>', '[');
    result = result.replaceAll('</chord>', ']');
    result = result.replaceAll('<verse>', '[/ Verse /]\n');
    result = result.replaceAll('</verse>', '\n\n');
    result = result.replaceAll('<chorus>', '[/ Chorus /]\n');
    result = result.replaceAll('</chorus>', '\n\n');
    result = result.replaceAll('<br />', '\n');
    result = result.replaceAll('<prechorus>', '[/ Prechorus /]\n');
    result = result.replaceAll('</prechorus>', '\n\n');
    result = result.replaceAll('<bridge>', '[/ Bridge /]\n');
    result = result.replaceAll('</bridge>', '\n\n');

    return result;
  }
}
