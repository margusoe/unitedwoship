import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

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
  bool _isLoading = true;

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
      if (mounted)
        setState(() {
          _items = items;
          _isLoading = false;
        });
    } catch (e) {
      debugPrint("Failed fetching setlist items: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // IMPORTANT: Specifically unsubscribe just the items to avoid breaking app-wide listeners later
    pb.collection('setlist_items').unsubscribe('*');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(widget.setlistTitle)),
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final title =
                    item.expand['song_id']?.first.getStringValue('title') ??
                        "Unknown Song";
                return CupertinoListTile(
                  title: Text(title),
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
