// lib/infrastructure/sync_manager.dart
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/song.dart';

class SyncManager {
  final _pb = getIt<PocketBaseService>().pb;
  final _db = getIt<SongDatabase>();

  Future<void> syncSongs() async {
    // 1. Get the latest update time we have locally
    final lastSync = await _db.getLastSyncDate();
    final filter = lastSync != null
        ? 'updated > "${lastSync.toUtc().toIso8601String().replaceAll('T', ' ')}"'
        : '';

    // 2. Fetch changes from PocketBase
    final records = await _pb.collection('songs').getFullList(
          filter: filter,
          sort: 'updated',
        );

    if (records.isEmpty) return;

    // 3. Convert records to Song objects and batch insert
    final songs = records.map((r) => Song.fromRecord(r)).toList();
    await _db.insertBatch(songs);
  }
}
