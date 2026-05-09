import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';
import 'package:unitedwoship/screens/set/add_song_to_setlist_screen.dart';

class SetlistDetailScreen extends StatefulWidget {
  final String setlistId;
  final String setlistTitle;
  final String ownerId;

  const SetlistDetailScreen({
    super.key,
    required this.setlistId,
    required this.setlistTitle,
    required this.ownerId,
  });

  @override
  State<SetlistDetailScreen> createState() => _SetlistDetailScreenState();
}

class _SetlistDetailScreenState extends State<SetlistDetailScreen> {
  final pb = getIt<PocketBaseService>().pb;
  final db = getIt<SongDatabase>();
  final syncManager = getIt<SyncManager>();

  List<SetlistItem> _items = []; // <-- NOW USING OUR OFFLINE MODEL
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalItems(); // Load offline data immediately

    // Wrap the internet subscription in a try/catch for Offline Mode!
    _subscribeToRealtimeChanges();
  }

  Future<void> _subscribeToRealtimeChanges() async {
    try {
      await pb.collection('setlist_items').subscribe('*', (e) async {
        if (e.record?.getStringValue('setlist_id') == widget.setlistId) {
          await syncManager.syncSetlists();
          _loadLocalItems();
        }
      });
    } catch (e) {
      // If we are offline, it will fail to connect. We just ignore it!
      debugPrint("Offline Mode: Real-time updates paused.");
    }
  }

  // --- READ FROM SQLITE (OFFLINE SUPPORT) ---
  Future<void> _loadLocalItems() async {
    final items = await db.getSetlistItems(widget.setlistId);
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    pb.collection('setlist_items').unsubscribe('*');
    super.dispose();
  }

  void _showShareDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Share Setlist'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(8),
                color: CupertinoColors.white,
                child: QrImageView(
                  data: widget.setlistId,
                  version: QrVersions.auto,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Scan this QR code, or share the Setlist ID below:'),
              const SizedBox(height: 8),
              Text(
                widget.setlistId,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Copy ID'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.setlistId));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditKeyCapoDialog(SetlistItem item) {
    final keyController = TextEditingController(text: item.selectedKey);
    final capoController = TextEditingController(text: item.capo.toString());

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Change Key & Capo'),
          content: Column(
            children: [
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: keyController,
                placeholder: 'Key (e.g. C, Cm, C7b9)',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: capoController,
                placeholder: 'Capo (0 - 12)',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                final newKey = keyController.text.trim();
                final newCapo = int.tryParse(capoController.text.trim()) ?? 0;

                Navigator.pop(context);
                setState(() => _isLoading = true);

                try {
                  // Push to server
                  await pb.collection('setlist_items').update(item.id, body: {
                    'selected_key': newKey,
                    'capo': newCapo,
                  });
                  // Sync to local DB
                  await syncManager.syncSetlists();
                  _loadLocalItems();
                } catch (e) {
                  debugPrint("Failed to update Key/Capo: $e");
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showItemOptions(SetlistItem item, String songTitle) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(songTitle),
        message: const Text('Manage this song in the setlist'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showEditKeyCapoDialog(item);
            },
            child: const Text('Change Key / Capo'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                // Delete from server
                await pb.collection('setlist_items').delete(item.id);
                // Sync local
                await syncManager.syncSetlists();
                _loadLocalItems();
              } catch (e) {
                debugPrint("Failed to remove song: $e");
                if (mounted) setState(() => _isLoading = false);
              }
            },
            child: const Text('Remove from Setlist'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = pb.authStore.model?.id;
    final isOwner = currentUserId == widget.ownerId;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.setlistTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  _showShareDialog();
                });
              },
              child: const Icon(CupertinoIcons.share),
            ),
            if (isOwner)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final existingIds =
                      _items.map((item) => item.songId).toList();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddSongToSetlistScreen(
                        setlistId: widget.setlistId,
                        existingSongIds: existingIds,
                      ),
                    ),
                  );
                },
                child: const Icon(CupertinoIcons.add),
              ),
          ],
        ),
      ),
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _items.isEmpty
              ? const Center(child: Text("No songs in this setlist yet."))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    // Offline Fetch for Song Title
                    return FutureBuilder<Song?>(
                      future: db.getSong(item.songId),
                      builder: (context, snapshot) {
                        final songTitle = snapshot.data?.title ?? "Loading...";

                        return GestureDetector(
                          onLongPress: isOwner
                              ? () => _showItemOptions(item, songTitle)
                              : null,
                          child: CupertinoListTile(
                            title: Text(songTitle),
                            subtitle: Text("Key: ${item.selectedKey}"),
                            trailing: const Icon(CupertinoIcons.chevron_forward,
                                color: CupertinoColors.systemGrey4),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SongScreen(
                                    items: _items,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
