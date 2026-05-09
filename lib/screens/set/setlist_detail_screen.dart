import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';
import 'package:unitedwoship/screens/set/add_song_to_setlist_screen.dart'; // <-- NEW IMPORT

class SetlistDetailScreen extends StatefulWidget {
  final String setlistId;
  final String setlistTitle;

  const SetlistDetailScreen(
      {super.key, required this.setlistId, required this.setlistTitle});

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.setlistTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // 1. Get the IDs of all songs currently in this setlist
            final existingIds =
                _items.map((item) => item.getStringValue('song_id')).toList();

            // 2. Pass them to the Add Screen
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddSongToSetlistScreen(
                  setlistId: widget.setlistId,
                  existingSongIds: existingIds, // <-- Passed here!
                ),
              ),
            );
          },
          child: const Icon(CupertinoIcons.add),
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

                    return CupertinoListTile(
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
                    );
                  },
                ),
    );
  }
}
