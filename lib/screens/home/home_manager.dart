import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart';

class HomeManager extends ChangeNotifier {
  final SongDatabase _db = getIt<SongDatabase>();
  final SyncManager _syncManager = getIt<SyncManager>();

  List<Song> songs = [];
  bool isLoading = false;
  bool isSyncing = false;

  Future<void> init() async {
    await loadSongs('');
    await syncWithServer();
  }

  Future<void> loadSongs(String query) async {
    isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      songs = await _db.getAllSongs();
    } else {
      songs = await _db.searchSongs(query);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> syncWithServer() async {
    isSyncing = true;
    notifyListeners();

    try {
      await _syncManager.syncSongs();
      await loadSongs(''); // Reload from local DB after sync
    } catch (e) {
      debugPrint("Sync failed: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> deleteSong(String songId) async {
    await _db.deleteSong(songId);
    await loadSongs('');
  }
}
