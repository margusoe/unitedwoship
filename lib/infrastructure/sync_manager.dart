import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart'; // <-- Add this

class SyncManager {
  final _pb = getIt<PocketBaseService>().pb;
  final _db = getIt<SongDatabase>();

  Future<void> syncSongs() async {
    final lastSync = await _db.getLastSyncDate();
    final filter = lastSync != null
        ? 'updated > "${lastSync.toUtc().toIso8601String().replaceAll('T', ' ')}"'
        : '';

    try {
      final records = await _pb.collection('songs').getFullList(
            filter: filter,
            sort: 'updated',
          );

      if (records.isEmpty) return;

      final songs = records.map((r) => Song.fromRecord(r)).toList();
      await _db.insertBatch(songs);
    } catch (e) {
      debugPrint("Song sync error: $e");
    }
  }

  // --- NEW: Sync Setlists ---
  Future<void> syncSetlists() async {
    final userId = _pb.authStore.model?.id ?? "";
    if (userId.isEmpty) return;

    try {
      // 1. Fetch setlists the user owns or subscribes to
      final setlistsRecords = await _pb.collection('setlists').getFullList(
            filter: 'owner = "$userId" || subscribers ~ "$userId"',
          );
      final setlists =
          setlistsRecords.map((r) => Setlist.fromRecord(r)).toList();

      // 2. Fetch all setlist items (PocketBase rules automatically filter this for us!)
      final itemsRecords = await _pb.collection('setlist_items').getFullList();
      final items = itemsRecords.map((r) => SetlistItem.fromRecord(r)).toList();

      // 3. Clear old local setlist data and insert the fresh data
      final db = await _db.database;
      await db.delete(SongDatabase.tableSetlistItems);
      await db.delete(SongDatabase.tableSetlists);

      await _db.insertSetlistsBatch(setlists);
      await _db.insertSetlistItemsBatch(items);
    } catch (e) {
      debugPrint("Setlist sync error: $e");
    }
  }
}
