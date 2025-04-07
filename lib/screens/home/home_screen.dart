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
      ),
      drawer: SizedBox(
        width: 300,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                // padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                decoration: BoxDecoration(
                  color: Color(0xFF4c4c4c),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: ColorFiltered(
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          child: Image.asset('assets/logo512.png',
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Магтаал Хүндэтгэл',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.grey.shade700),
                title: Text('Дуу нэмэх'),
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
                title: Text('Тохиргоо'),
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
                title: Text('Бидний тухай'),
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
      ),
      body: ValueListenableBuilder<List<(int, String)>>(
          valueListenable: _manager.songListNotifier,
          builder: (context, songList, child) {
            if (songList.isEmpty) {
              return Center(
                child: Text('Дуу олдсонгүй. Та дуу нэмнэ үү.'),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Дуу Засах'),
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
                title: Text('Дуу Устгах'),
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
          title: Text('Зөвшөөрөх'),
          content: Text('Энэ дууг устгахыг зөвшөөрч байна уу?'),
          actions: <Widget>[
            TextButton(
              child: Text('Үгүй'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Тийм'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
