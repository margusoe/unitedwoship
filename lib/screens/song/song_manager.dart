import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';

class SongManager extends ChangeNotifier {
  final db = getIt<SongDatabase>();

  Song? song;
  bool isLoading = true;
  bool isFavorite = false;

  Future<void> loadSong(String songId) async {
    isLoading = true;
    notifyListeners();

    song = await db.getSong(songId);
    isFavorite = song?.isFavorite ?? false;

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (song != null) {
      isFavorite = !isFavorite;
      await db.toggleFavorite(song!.id, isFavorite);
      notifyListeners();
    }
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
