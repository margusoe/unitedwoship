import 'package:flutter/material.dart';
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

  @override
  initState() {
    super.initState();
    _manager.init(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How Great is Our God'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<SongModel?>(
          valueListenable: _manager.lyricsNotifier,
          builder: (context, song, child) {
            if (song == null) {
              return const SizedBox();
            }
            return Text(song.lyrics);
          },
        ),
      ),
    );
  }
}
