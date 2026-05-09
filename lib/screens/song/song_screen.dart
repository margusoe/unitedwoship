// lib/screens/song/song_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart'; // Replaced web_api
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SongScreen extends StatefulWidget {
  final String songId; // Ensure this is String
  const SongScreen({super.key, required this.songId});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final db = getIt<SongDatabase>();
  final _manager = SongManager();
  final _transposeValue = 0;
  final userSettings = getIt<UserSettings>();

  late Future<Song?> _futureSong;

  @override
  void initState() {
    super.initState();
    // Load the song asynchronously from the database
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

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(),
              child: Center(child: Text('Song not found')),
            );
          }

          final song = snapshot.data!;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.pop(context),
              ),
              middle: Text(song.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // TODO: Implement favorite functionality
                    },
                    child: const Icon(CupertinoIcons.heart),
                  ),
                  if (song.mediaLink.isNotEmpty) // Updated from youtubeLink
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        final uri = Uri.parse(song.mediaLink);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          if (!context.mounted) return;
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('Could not open YouTube link.'),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Icon(CupertinoIcons.play_rectangle),
                    ),
                ],
              ),
            ),
            child: ValueListenableBuilder<double>(
              valueListenable: userSettings.fontSize,
              builder: (context, fontSize, child) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LyricsRenderer(
                      widgetPadding: 64,
                      lyrics: _manager
                          .formatLyrics(song.lyrics), // Updated from songxml
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: fontSize),
                      chordStyle: TextStyle(
                          fontSize: fontSize,
                          color: Theme.of(context).colorScheme.primary),
                      transposeIncrement: _transposeValue,
                      onTapChord: (chord) {},
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
