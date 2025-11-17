import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';

class SongScreen extends StatefulWidget {
  final int songId;
  const SongScreen({super.key, required this.songId});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  late Song song;
  final webApi = getIt<WebApi>();
  final _manager = SongManager();
  final _transposeValue = 0;

  @override
  void initState() {
    super.initState();
    song = webApi.getSong(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return LyricsRenderer(
        lyrics: _manager.formatLyrics(song.songxml),
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: _manager.fontSize),
        chordStyle: TextStyle(
            fontSize: _manager.fontSize,
            color: Theme.of(context).colorScheme.secondary),
        transposeIncrement: _transposeValue,
        onTapChord: (chord) {});
  }
}
