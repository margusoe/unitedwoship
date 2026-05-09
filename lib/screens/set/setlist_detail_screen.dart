// lib/screens/set/setlist_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/live_mode_manager.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class SetlistDetailScreen extends StatefulWidget {
  final String setlistId;
  final String setlistTitle;

  const SetlistDetailScreen({
    super.key,
    required this.setlistId,
    required this.setlistTitle,
  });

  @override
  State<SetlistDetailScreen> createState() => _SetlistDetailScreenState();
}

class _SetlistDetailScreenState extends State<SetlistDetailScreen> {
  final pbService = getIt<PocketBaseService>();
  final _liveManager = getIt<LiveModeManager>();
  List<RecordModel> _items = [];

  @override
  void initState() {
    super.initState();
    // Subscribe to live updates for this specific setlist
    _liveManager.subscribeToSetlist(widget.setlistId);
    // Listen for changes to the active item ID
    _liveManager.activeItemId.addListener(_handleLiveChange);
  }

  void _handleLiveChange() {
    final activeId = _liveManager.activeItemId.value;

    // Check if we are currently on this screen to avoid weird navigation bugs
    if (activeId != null && ModalRoute.of(context)?.isCurrent == true) {
      final item = _items.firstWhere(
        (i) => i.id == activeId,
        orElse: () => _items.first,
      );

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SongScreen(
            songId: item.getStringValue('song_id'),
            overrideKey: item.getStringValue('selected_key'),
            overrideCapo: item.getIntValue('capo'),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _liveManager.activeItemId.removeListener(_handleLiveChange);
    _liveManager.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.setlistTitle),
      ),
      child: SafeArea(
        child: FutureBuilder<List<RecordModel>>(
          future: pbService.getSetlistItems(widget.setlistId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            _items = snapshot.data ?? [];

            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final songData = item.expand['song_id']?.first;
                final songTitle =
                    songData?.getStringValue('title') ?? "Unknown Song";

                return CupertinoListTile(
                  title: Text(songTitle),
                  subtitle: Text(
                    "Key: ${item.getStringValue('selected_key')} | Capo: ${item.getIntValue('capo')}",
                  ),
                  onTap: () {
                    // Update PocketBase (This triggers the listener for everyone)
                    _liveManager.setLiveItem(widget.setlistId, item.id);
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
