import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/song.dart';

class AddSongToSetlistScreen extends StatefulWidget {
  final String setlistId;
  final List<String> existingSongIds; // <-- NEW: Receive existing songs

  const AddSongToSetlistScreen({
    super.key,
    required this.setlistId,
    required this.existingSongIds,
  });

  @override
  State<AddSongToSetlistScreen> createState() => _AddSongToSetlistScreenState();
}

class _AddSongToSetlistScreenState extends State<AddSongToSetlistScreen> {
  final db = getIt<SongDatabase>();
  final pb = getIt<PocketBaseService>().pb;

  List<Song> _songs = [];
  bool _isLoading = true;

  // Track which songs are added so we can update the UI instantly
  late Set<String> _addedSongIds;

  @override
  void initState() {
    super.initState();
    // Initialize our set with the songs already in the setlist
    _addedSongIds = Set.from(widget.existingSongIds);
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await db.getAllSongs();
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  Future<void> _addSong(Song song) async {
    // 1. Double check it's not already added
    if (_addedSongIds.contains(song.id)) return;

    try {
      await pb.collection('setlist_items').create(body: {
        'setlist_id': widget.setlistId,
        'song_id': song.id,
        'sort_order': _addedSongIds.length, // Put at the bottom of the list
        'selected_key': song.originalKey,
        'capo': 0,
      });

      // 2. Update the UI to show a checkmark instantly
      if (mounted) {
        setState(() {
          _addedSongIds.add(song.id);
        });
      }
    } catch (e) {
      debugPrint("Failed to add song to setlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Select Song'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  final isAdded =
                      _addedSongIds.contains(song.id); // <-- Check if added

                  return CupertinoListTile(
                    title: Text(
                      song.title,
                      style: TextStyle(
                        color: isAdded ? CupertinoColors.systemGrey : null,
                      ),
                    ),
                    subtitle: Text('Key: ${song.originalKey}'),
                    // Show a checkmark if already added, otherwise a +
                    trailing: Icon(
                      isAdded
                          ? CupertinoIcons.checkmark_alt_circle_fill
                          : CupertinoIcons.add_circled,
                      color: isAdded
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.activeBlue,
                    ),
                    // Disable the tap if already added
                    onTap: isAdded ? null : () => _addSong(song),
                  );
                },
              ),
      ),
    );
  }
}
