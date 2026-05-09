import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final homeManager = getIt<HomeManager>();
  final userSettings = getIt<UserSettings>();

  @override
  void initState() {
    super.initState();
    homeManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: homeManager,
        builder: (context, _) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Search'),
              trailing: homeManager.isSyncing
                  ? const CupertinoActivityIndicator()
                  : null,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoSearchTextField(
                      placeholder: 'Search by song title...',
                      onChanged: (value) => homeManager.loadSongs(value),
                    ),
                  ),
                  Expanded(
                    child: homeManager.isLoading && homeManager.songs.isEmpty
                        ? const Center(child: CupertinoActivityIndicator())
                        : homeManager.songs.isEmpty
                            ? Center(
                                child: Text(
                                  homeManager.isSyncing
                                      ? 'Syncing songs...'
                                      : 'No songs found.',
                                  style: const TextStyle(
                                      color: CupertinoColors.systemGrey),
                                ),
                              )
                            : ValueListenableBuilder<double>(
                                valueListenable: userSettings.fontSize,
                                builder: (context, fontSize, child) {
                                  return ListView.builder(
                                    itemCount: homeManager.songs.length,
                                    itemBuilder: (context, index) {
                                      final song = homeManager.songs[index];
                                      return CupertinoListTile(
                                        title: Text(
                                          song.title,
                                          style: TextStyle(fontSize: fontSize),
                                        ),
                                        subtitle:
                                            Text('Key: ${song.originalKey}'),
                                        trailing: const Icon(
                                          CupertinoIcons.chevron_forward,
                                          color: CupertinoColors.systemGrey4,
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
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
