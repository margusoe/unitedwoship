// lib/screens/song/song_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SongScreen extends StatefulWidget {
  final String songId;
  // Optional parameters: if these are provided, we are in "Setlist Mode"
  final String? overrideKey;
  final int? overrideCapo;

  const SongScreen({
    super.key,
    required this.songId,
    this.overrideKey,
    this.overrideCapo,
  });

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final db = getIt<SongDatabase>();
  final _manager = SongManager();
  final userSettings = getIt<UserSettings>();

  late Future<Song?> _futureSong;

  @override
  void initState() {
    super.initState();
    _futureSong = db.getSong(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Song?>(
        future: _futureSong,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(),
              child: Center(child: CupertinoActivityIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(),
              child: Center(child: Text('Song not found')),
            );
          }

          final song = snapshot.data!;
          // Determine values to show
          final displayKey = widget.overrideKey ?? song.originalKey;
          final displayCapo = widget.overrideCapo ?? 0;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(song.title),
              trailing: song.mediaLink.isNotEmpty
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => launchUrl(Uri.parse(song.mediaLink)),
                      child: const Icon(CupertinoIcons.play_rectangle),
                    )
                  : null,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Transposition Info Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoBadge("Key: $displayKey"),
                        _infoBadge("Capo: $displayCapo"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<double>(
                      valueListenable: userSettings.fontSize,
                      builder: (context, fontSize, child) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: LyricsRenderer(
                            widgetPadding: 64,
                            lyrics: _manager.formatLyrics(song.lyrics),
                            textStyle: TextStyle(
                              fontSize: fontSize,
                              color: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color,
                            ),
                            chordStyle: TextStyle(
                              fontSize: fontSize * 0.9,
                              color: CupertinoTheme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            transposeIncrement:
                                0, // You can implement real-time transpose here
                            onTapChord: (chord) {},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _infoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
