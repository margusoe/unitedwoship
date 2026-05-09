// lib/screens/favorites/favorites_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/song/song_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final db = getIt<SongDatabase>();
  final userSettings = getIt<UserSettings>();
  late Future<List<Song>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _futureFavorites = db.getFavoriteSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorites'),
      ),
      child: SafeArea(
        child: FutureBuilder<List<Song>>(
          future: _futureFavorites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorite songs yet.'));
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
                      title: Text(song.title,
                          style: TextStyle(fontSize: fontSize)),
                      subtitle: Text('Key: ${song.originalKey}'),
                      trailing: const Icon(CupertinoIcons.heart_fill,
                          color: CupertinoColors.destructiveRed, size: 20),
                      onTap: () async {
                        // Await the push so we can refresh the list if the user
                        // removes the favorite status while on the SongScreen
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SongScreen(songId: song.id),
                          ),
                        );
                        _loadFavorites();
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
