import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/screens/about/about_screen.dart';
import 'package:magtaalhundetgel/screens/home/home_manager.dart';
import 'package:magtaalhundetgel/infrastructure/service_locator.dart';
import 'package:magtaalhundetgel/screens/add_edit_song/add_edit_song_screen.dart';
import 'package:magtaalhundetgel/screens/settings/settings_screen.dart';
import 'package:magtaalhundetgel/screens/song/song_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _manager = getIt<HomeManager>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _manager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магтаал Хүндэтгэл'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       showSearch(context: context, delegate: CustomSearchDelegate());
        //     },
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 130,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF4c4c4c),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                          child: ColorFiltered(
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        child: Image.asset('assets/logo512.png',
                            fit: BoxFit.contain),
                      )),
                      SizedBox(height: 8),
                      Text('Магтаал Хүндэтгэл',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.grey.shade700),
              title: Text('Add Song'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditSongScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey.shade700),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.grey.shade700),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<(int, String)>>(
          valueListenable: _manager.songListNotifier,
          builder: (context, songList, child) {
            if (songList.isEmpty) {
              return Center(
                child: Text('No songs found. Please add a song.'),
              );
            }
            return ListView.builder(
              itemCount: songList.length,
              itemBuilder: (context, index) {
                final (songId, title) = songList[index];
                return ListTile(
                  title: Text(
                    title,
                  ),
                  leading: Icon(Icons.lyrics, color: Colors.grey.shade700),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongScreen(
                          songId: songId,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showSongOptions(songId);
                  },
                );
              },
            );
          }),
    );
  }

  Future<void> _showSongOptions(int songId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Song Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditSongScreen(
                        songId: songId,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () async {
                  Navigator.pop(context);
                  final shouldDelete = await _confirmDelete();
                  if (shouldDelete) {
                    _manager.deleteSong(songId);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this song?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        'Search Results for "$query"',
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: query.isEmpty ? 0 : 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            'Suggestion ${index + 1} for "$query"',
          ),
          onTap: () {
            query = 'Suggestion ${index + 1}';
            showResults(context);
          },
        );
      },
    );
  }
}
