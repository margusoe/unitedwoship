import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final appstatemanager = getIt<AppStateManager>();
  final webApi = getIt<WebApi>();
  final userSettings = getIt<UserSettings>();
  late Future<List<Song>> _futureSongs;

  @override
  void initState() {
    super.initState();
    _futureSongs = _loadSongs();
  }

  Future<List<Song>> _loadSongs() async {
    await webApi.loadSongs();
    return webApi.songs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = appstatemanager.theme;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Search'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CupertinoSearchTextField(),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<double>(
                valueListenable: userSettings.fontSize,
                builder: (context, fontSize, child) {
                  return FutureBuilder<List<Song>>(
                    future: _futureSongs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No songs found.'));
                      } else {
                        // If data is loaded successfully, display it in a ListView
                        final songs = snapshot.data!;
                        return ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return CupertinoListTile(
                              title: Text(
                                song.title,
                                style: TextStyle(fontSize: fontSize),
                              ),
                              subtitle: Text(
                                'Key: ${song.songkey}',
                                style: TextStyle(
                                    fontSize:
                                        fontSize * 0.8), // Adjust as needed
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        SongScreen(songId: song.id),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
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
