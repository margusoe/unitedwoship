import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class AddSongManager {
  final SongDatabase _lyricsDatabase = getIt<SongDatabase>();

  Future<int> addSong({
    required String songName,
    required String composer,
    required String lyricAuthor,
    required String originalKey,
    required String lyrics,
  }) async {
    final lyricsModel = SongModel(
      title: songName,
      composer: composer,
      lyricAuthor: lyricAuthor,
      originalKey: originalKey,
      lyrics: lyrics,
      dateAdded: DateTime.now(),
    );

    return await _lyricsDatabase.createSong(lyricsModel);
  }
}
