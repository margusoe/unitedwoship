import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class AddEditSongManager {
  final SongDatabase _lyricsDatabase = getIt<SongDatabase>();

  Future<void> saveSong({
    int? songId,
    required String songName,
    required String composer,
    required String lyricAuthor,
    required String lyrics,
  }) async {
    final lyricsModel = SongModel(
      songId: songId,
      title: songName,
      composer: composer,
      lyricAuthor: lyricAuthor,
      lyrics: lyrics,
      dateAdded: DateTime.now(),
    );
    if (songId == null) {
      await _lyricsDatabase.createSong(lyricsModel);
    } else {
      await _lyricsDatabase.updateSong(lyricsModel);
    }
    ;
    final homeManager = getIt<HomeManager>();
    homeManager.init();
  }

  Future<SongModel?> getSongModel(int? songId) async {
    if (songId == null) {
      return null;
    }
    final song = await _lyricsDatabase.getSong(songId);
    return song;
  }
}
