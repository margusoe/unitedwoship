// lib/screens/song/song_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
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
  final db = getIt<SongDatabase>();

  late ValueNotifier<String?> _currentSongId;
  late ValueNotifier<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);

    // Determine the initial song ID based on single mode or setlist mode
    String? initialId = widget.songId;
    if (widget.items != null && widget.items!.isNotEmpty) {
      initialId = widget.items![widget.initialIndex].getStringValue('song_id');
    }

    _currentSongId = ValueNotifier<String?>(initialId);
    _isFavorite = ValueNotifier<bool>(false);

    _checkFavorite();
  }

  void _checkFavorite() async {
    if (_currentSongId.value != null) {
      final song = await db.getSong(_currentSongId.value!);
      _isFavorite.value = song?.isFavorite ?? false;
    }
  }

  void _toggleFavorite() async {
    if (_currentSongId.value != null) {
      final newValue = !_isFavorite.value;
      await db.toggleFavorite(_currentSongId.value!, newValue);
      _isFavorite.value = newValue;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentSongId.dispose();
    _isFavorite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSetlistMode = widget.items != null && widget.items!.isNotEmpty;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Worship"),
        trailing: ValueListenableBuilder<bool>(
          valueListenable: _isFavorite,
          builder: (context, isFav, child) {
            if (_currentSongId.value == null) return const SizedBox();
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _toggleFavorite,
              child: Icon(
                isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isFav
                    ? CupertinoColors.destructiveRed
                    : CupertinoTheme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
      child: isSetlistMode
          ? PageView.builder(
              controller: _pageController,
              itemCount: widget.items!.length,
              onPageChanged: (index) {
                _currentSongId.value =
                    widget.items![index].getStringValue('song_id');
                _checkFavorite(); // Recheck favorite status on swipe
              },
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
                  songId: widget.songId!,
                  keyOverride: "",
                  capoOverride: 0,
                )
              : const Center(child: Text("No song selected"))),
    );
  }
}

class _SongView extends StatefulWidget {
  final String songId;
  final String keyOverride;
  final int capoOverride;

  const _SongView({
    required this.songId,
    required this.keyOverride,
    required this.capoOverride,
  });

  @override
  State<_SongView> createState() => _SongViewState();
}

class _SongViewState extends State<_SongView> {
  final manager = SongManager();
  final userSettings = getIt<UserSettings>();

  @override
  void initState() {
    super.initState();
    manager.loadSong(widget.songId);
  }

  @override
  void didUpdateWidget(covariant _SongView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.songId != widget.songId) {
      manager.loadSong(widget.songId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        if (manager.isLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final song = manager.song;
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
                        "Key: ${widget.keyOverride.isNotEmpty ? widget.keyOverride : song.originalKey}"),
                    const SizedBox(width: 10),
                    _infoBadge("Capo: ${widget.capoOverride}"),
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
