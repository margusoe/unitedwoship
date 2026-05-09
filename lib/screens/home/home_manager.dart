import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart';

class HomeManager extends ChangeNotifier {
  final SongDatabase _db = getIt<SongDatabase>();
  final SyncManager _syncManager = getIt<SyncManager>();

  List<Song> songs = [];
  List<Song> favoriteSongs = []; // <-- NEW: Hold favorites here

  bool isLoading = false;
  bool isSyncing = false;

  Timer? _debounce;

  Future<void> init() async {
    await loadSongs('');
    await loadFavorites(); // <-- NEW: Load favorites on startup
    await syncWithServer();
  }

  // --- NEW: Load Favorites Method ---
  Future<void> loadFavorites() async {
    favoriteSongs = await _db.getFavoriteSongs();
    notifyListeners();
  }

  Future<void> loadSongs(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      isLoading = true;
      notifyListeners();

      if (query.isEmpty) {
        songs = await _db.getAllSongs();
      } else {
        songs = await _db.searchSongs(query);
      }

      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> syncWithServer() async {
    isSyncing = true;
    notifyListeners();

    try {
      await _syncManager.syncSongs();
      await loadSongs('');
      await loadFavorites(); // <-- NEW: Reload favorites after sync
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
    await loadFavorites(); // <-- NEW: Reload favorites if a song is deleted
  }
}
