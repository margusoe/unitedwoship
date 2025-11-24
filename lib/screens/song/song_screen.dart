import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
              if (song.youtubeLink.isNotEmpty)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final uri = Uri.parse(song.youtubeLink);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      // Handle error: could not launch URL
                      // For example, show a CupertinoAlertDialog
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text('Error'),
                          content: const Text('Could not open YouTube link.'),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LyricsRenderer(
              widgetPadding: 64,
              lyrics: _manager.formatLyrics(song.songxml),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: _manager.fontSize),
              chordStyle: TextStyle(
                  fontSize: _manager.fontSize,
                  color: Theme.of(context).colorScheme.primary),
              transposeIncrement: _transposeValue,
              onTapChord: (chord) {}),
        ));
  }
}
