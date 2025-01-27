import 'package:flutter/material.dart';
import 'package:unitedwoship/home/home_manager.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/screens/add_song/add_song_screen.dart';
import 'package:unitedwoship/screens/song_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _manager = HomeManager();
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
        title: Text('Flutter App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search action here
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
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
                child: Text('United Worship',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.grey.shade700),
              title: Text('Add Song'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSongScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey.shade700),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<SongModel>>(
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
                return ListTile(
                  title: Text(
                    songList[index].songName,
                  ),
                  leading: Icon(Icons.label, color: Colors.grey.shade700),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongScreen(),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
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
