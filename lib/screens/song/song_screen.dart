import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('How Great is Our God'), actions: [
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            setState(() {
              _transposeValue++;
            });
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
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<SongModel?>(
          valueListenable: _manager.lyricsNotifier,
          builder: (context, song, child) {
            if (song == null) {
              return const SizedBox();
            }
            return LyricsRenderer(
              lyrics: song.lyrics,
              textStyle: Theme.of(context).textTheme.bodyMedium!,
              chordStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),
              transposeIncrement: _transposeValue,
              onTapChord: (chord) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Chord $chord',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16.0),
                            FlutterLogo(),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
