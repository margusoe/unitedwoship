// lib/screens/set/setlist_detail_screen.dart
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
  final pbService = getIt<PocketBaseService>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(widget.setlistTitle)),
      child: FutureBuilder<List<RecordModel>>(
        // Using the helper we defined earlier
        future: pbService.getSetlistItems(widget.setlistId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CupertinoActivityIndicator());

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              // Access the expanded 'song_id' data
              final songData = item.expand['song_id']?.first;
              final songTitle =
                  songData?.getStringValue('title') ?? "Unknown Song";

              return CupertinoListTile(
                title: Text(songTitle),
                subtitle: Text(
                    "Key: ${item.getStringValue('selected_key')} | Capo: ${item.getIntValue('capo')}"),
                onTap: () {
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
                },
              );
            },
          );
        },
      ),
    );
  }
}
