import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final homeManager = getIt<HomeManager>();
  final userSettings = getIt<UserSettings>();

  @override
  void initState() {
    super.initState();
    // Fetch latest when the screen opens just in case
    homeManager.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder auto-rebuilds whenever HomeManager notifies listeners!
    return ListenableBuilder(
        listenable: homeManager,
        builder: (context, child) {
          final songs = homeManager.favoriteSongs;

          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Favorites'),
            ),
            child: SafeArea(
              child: songs.isEmpty
                  ? const Center(child: Text('No favorite songs yet.'))
                  : ValueListenableBuilder<double>(
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
                              trailing: const Icon(CupertinoIcons.heart_fill,
                                  color: CupertinoColors.destructiveRed,
                                  size: 20),
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
          );
        });
  }
}
