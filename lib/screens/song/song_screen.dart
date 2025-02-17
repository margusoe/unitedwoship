import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/screens/add_edit_song/add_edit_song_screen.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({
    super.key,
    required this.songId,
  });

  final int songId;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final _manager = SongManager();
  int _transposeValue = 0;

  @override
  initState() {
    super.initState();
    _manager.init(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SongModel?>(
        valueListenable: _manager.lyricsNotifier,
        builder: (context, song, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(song?.title ?? ''),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    setState(
                      () {
                        _transposeValue++;
                      },
                    );
                  },
                ),
                Text(_transposeValue.toString()),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      _transposeValue--;
                    });
                  },
                ),
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEditSongScreen(songId: widget.songId),
                      ),
                    );
                    _manager.init(widget.songId);
                  },
                  icon: Icon(Icons.edit_note),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildBody(song),
            ),
          );
        });
  }

  Widget _buildBody(SongModel? song) {
    if (song == null) {
      return const SizedBox();
    }
    final screenWidth = MediaQuery.sizeOf(context).width;
    print(Theme.of(context).colorScheme.secondary);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 0 : 58),
      child: LyricsRenderer(
          lyrics: song.lyrics,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: _manager.fontSize),
          chordStyle: TextStyle(
              fontSize: _manager.fontSize,
              color: Theme.of(context).colorScheme.secondary),
          transposeIncrement: _transposeValue,
          onTapChord: (chord) {}),
    );
  }
}
