import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final db = getIt<SongDatabase>();
  final userSettings = getIt<UserSettings>();
  late Future<List<Song>> _futureSongs;

  @override
  void initState() {
    super.initState();
    _futureSongs = db.getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Search')),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(),
            ),
            Expanded(
              child: FutureBuilder<List<Song>>(
                future: _futureSongs,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CupertinoActivityIndicator());
                  final songs = snapshot.data!;

                  return ValueListenableBuilder<double>(
                    valueListenable: userSettings.fontSize,
                    builder: (context, fontSize, child) {
                      return ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return CupertinoListTile(
                            title: Text(song.title,
                                style: TextStyle(fontSize: fontSize)),
                            subtitle: Text('Key: ${song.originalKey}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SongScreen(
                                    songId:
                                        song.id, // Ensure song.id is not null
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

// A simple wrapper to handle "Global Mode"
class _GlobalSongWrapper extends StatelessWidget {
  final String songId;
  const _GlobalSongWrapper({required this.songId});

  @override
  Widget build(BuildContext context) {
    // We create a dummy list with one item for the PageView to work
    return SongScreen(
      items: null, // Signals it's not a setlist
      initialIndex: 0,
      // We need to pass the ID via a custom logic or update SongScreen slightly.
      // Let's do the simple fix below.
    );
  }
}
