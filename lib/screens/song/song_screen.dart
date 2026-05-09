// lib/screens/song/song_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/song/song_manager.dart';

class SongScreen extends StatefulWidget {
  final String? songId;
  final List<RecordModel>? items;
  final int initialIndex;

  const SongScreen({
    super.key,
    this.songId,
    this.items,
    this.initialIndex = 0,
  });

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are in setlist mode
    final isSetlistMode = widget.items != null && widget.items!.isNotEmpty;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Worship")),
      child: isSetlistMode
          ? PageView.builder(
              controller: _pageController,
              itemCount: widget.items!.length,
              itemBuilder: (context, index) {
                final item = widget.items![index];
                return _SongView(
                  songId: item.getStringValue('song_id'),
                  keyOverride: item.getStringValue('selected_key'),
                  capoOverride: item.getIntValue('capo'),
                );
              },
            )
          : (widget.songId != null
              ? _SongView(
                  songId: widget.songId!, // Safe because we checked != null
                  keyOverride: "",
                  capoOverride: 0,
                )
              : const Center(
                  child: Text("No song selected"))), // Safety fallback
    );
  }
}

class _SongView extends StatelessWidget {
  final String songId;
  final String keyOverride;
  final int capoOverride;

  const _SongView({
    required this.songId,
    required this.keyOverride,
    required this.capoOverride,
  });

  @override
  Widget build(BuildContext context) {
    final db = getIt<SongDatabase>();
    final manager = SongManager();
    final userSettings = getIt<UserSettings>();

    return FutureBuilder<Song?>(
      future: db.getSong(songId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final song = snapshot.data;
        if (song == null) return const Center(child: Text("Song not found"));

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(song.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoBadge(
                        "Key: ${keyOverride.isNotEmpty ? keyOverride : song.originalKey}"),
                    const SizedBox(width: 10),
                    _infoBadge("Capo: $capoOverride"),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LyricsRenderer(
                    lyrics: manager.formatLyrics(song.lyrics),
                    textStyle: TextStyle(
                        fontSize: userSettings.fontSize.value,
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color),
                    chordStyle: TextStyle(
                        fontSize: userSettings.fontSize.value * 0.9,
                        color: CupertinoTheme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                    transposeIncrement: 0,
                    onTapChord: (chord) {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
