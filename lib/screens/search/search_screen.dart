import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart'; // Added SyncManager
import 'package:unitedwoship/screens/song/song_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final db = getIt<SongDatabase>();
  final userSettings = getIt<UserSettings>();
  final syncManager = getIt<SyncManager>();

  late Future<List<Song>> _futureSongs;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadSongs(); // Load whatever is currently in SQLite
    _syncWithServer(); // Fetch new data from PocketBase in the background
  }

  // Loads songs from SQLite (optionally filtered by a search query)
  void _loadSongs([String query = '']) {
    setState(() {
      if (query.isEmpty) {
        _futureSongs = db.getAllSongs();
      } else {
        _futureSongs = db.searchSongs(query);
      }
    });
  }

  // Pulls the latest changes from PocketBase and updates the UI
  Future<void> _syncWithServer() async {
    setState(() => _isSyncing = true);
    try {
      await syncManager.syncSongs();
      if (mounted) {
        _loadSongs(); // Refresh the list with the newly synced data
      }
    } catch (e) {
      debugPrint("Sync failed: $e");
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Search'),
        // Show a loading spinner in the top right while syncing with PocketBase
        trailing: _isSyncing ? const CupertinoActivityIndicator() : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search by song title...',
                // Wire up the search field!
                onChanged: (value) => _loadSongs(value),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Song>>(
                future: _futureSongs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !_isSyncing) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        _isSyncing ? 'Syncing songs...' : 'No songs found.',
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    );
                  }

                  final songs = snapshot.data!;

                  return ValueListenableBuilder<double>(
                    valueListenable: userSettings.fontSize,
                    builder: (context, fontSize, child) {
                      return ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return CupertinoListTile(
                            title: Text(
                              song.title,
                              style: TextStyle(fontSize: fontSize),
                            ),
                            subtitle: Text('Key: ${song.originalKey}'),
                            trailing: const Icon(
                              CupertinoIcons.chevron_forward,
                              color: CupertinoColors.systemGrey4,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SongScreen(
                                    songId: song.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
