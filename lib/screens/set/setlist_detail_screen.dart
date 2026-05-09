import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';
import 'package:unitedwoship/screens/set/add_song_to_setlist_screen.dart'; // <-- NEW IMPORT

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
  List<RecordModel> _items = [];
  bool _isLoading = true; // <-- ADDED THIS

  @override
  void initState() {
    super.initState();
    _fetchItems();

    // Listen strictly to setlist_items changes for THIS setlist
    pb.collection('setlist_items').subscribe('*', (e) {
      if (e.record?.getStringValue('setlist_id') == widget.setlistId) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    try {
      final items = await pb.collection('setlist_items').getFullList(
            filter: 'setlist_id = "${widget.setlistId}"',
            expand: 'song_id',
            sort: 'sort_order',
          );
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false; // <-- Turn off loading spinner when done
        });
      }
    } catch (e) {
      debugPrint("Failed fetching setlist items: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Unsubscribe just the items to avoid breaking app-wide listeners
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
            mainAxisSize: MainAxisSize
                .min, // <-- Prevents column from expanding infinitely
            children: [
              // We replaced 'Center' with strict width/height to fix the LayoutBuilder crash
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

  void _showEditKeyCapoDialog(
      RecordModel item, String currentKey, int currentCapo) {
    final keyController = TextEditingController(text: currentKey);
    final capoController = TextEditingController(text: currentCapo.toString());

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
                textCapitalization: TextCapitalization
                    .words, // Auto-capitalizes the first letter
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: capoController,
                placeholder: 'Capo (0 - 12)',
                keyboardType:
                    TextInputType.number, // Opens the number pad automatically
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
                // Ensure Capo is a valid number, default to 0 if they typed letters by mistake
                final newCapo = int.tryParse(capoController.text.trim()) ?? 0;

                Navigator.pop(context); // Close dialog
                setState(() => _isLoading = true);

                try {
                  // Update the item in PocketBase
                  await pb.collection('setlist_items').update(item.id, body: {
                    'selected_key': newKey,
                    'capo': newCapo,
                  });
                  // The UI will auto-refresh thanks to our PocketBase subscription!
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

  void _showItemOptions(RecordModel item, String songTitle) {
    // Extract current values safely
    final currentKey = item.getStringValue('selected_key');
    final currentCapo = item.getIntValue('capo');

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(songTitle),
        message: const Text('Manage this song in the setlist'),
        actions: <CupertinoActionSheetAction>[
          // --- NEW EDIT BUTTON ---
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // Close the action sheet
              _showEditKeyCapoDialog(
                  item, currentKey, currentCapo); // Open the picker
            },
            child: const Text('Change Key / Capo'),
          ),

          // Existing Delete Button
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await pb.collection('setlist_items').delete(item.id);
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
    // Check if the current user owns this setlist
    final currentUserId = pb.authStore.model?.id;
    final isOwner = currentUserId == widget.ownerId;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.setlistTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. SHARE BUTTON (Everyone can see this to copy the code)
            // 1. SHARE BUTTON
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Delaying the dialog by "zero" duration breaks it out of
                // the current animation frame and prevents the Flutter framework crash!
                Future.delayed(Duration.zero, () {
                  _showShareDialog();
                });
              },
              child: const Icon(CupertinoIcons.share),
            ),

            // 2. ADD SONG BUTTON (ONLY visible if they are the owner!)
            if (isOwner)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final existingIds = _items
                      .map((item) => item.getStringValue('song_id'))
                      .toList();

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
                    final title =
                        item.expand['song_id']?.first.getStringValue('title') ??
                            "Unknown Song";
                    final key = item.getStringValue('selected_key');

                    // Check owner status again inside the builder
                    final currentUserId = pb.authStore.model?.id;
                    final isOwner = currentUserId == widget.ownerId;

                    return GestureDetector(
                      // ONLY trigger long press if they are the owner!
                      onLongPress:
                          isOwner ? () => _showItemOptions(item, title) : null,
                      child: CupertinoListTile(
                        title: Text(title),
                        subtitle: Text("Key: $key"),
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
                ),
    );
  }
}
