import 'package:unitedwoship/infrastructure/in_app_storage.dart';

class AddSongManager {
  final LyricsDatabase _lyricsDatabase = LyricsDatabase.instance;

  Future<int> addSong({
    required String songName,
    required String composer,
    required String lyricAuthor,
    required String originalKey,
    required String lyrics,
  }) async {
    final lyricsModel = LyricsModel(
      songName: songName,
      composer: composer,
      lyricAuthor: lyricAuthor,
      originalKey: originalKey,
      lyrics: lyrics,
      dateAdded: DateTime.now(),
    );

    return await _lyricsDatabase.createLyrics(lyricsModel);
  }
}
