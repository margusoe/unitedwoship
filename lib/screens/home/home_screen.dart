import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/screens/add/add_screen.dart';
import 'package:unitedwoship/screens/favorites/favorites_screen.dart';
import 'package:unitedwoship/screens/profile/profile_screen.dart';
import 'package:unitedwoship/screens/search/search_screen.dart';
import 'package:unitedwoship/screens/set/set_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.search,
              size: 20,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart,
              size: 20,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.add,
              size: 20,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.music_note,
              size: 20,
            ),
            label: 'Set',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => const SearchScreen());
          case 1:
            return CupertinoTabView(
                builder: (context) => const FavoritesScreen());
          case 2:
            return CupertinoTabView(builder: (context) => const AddScreen());
          case 3:
            return CupertinoTabView(builder: (context) => const SetScreen());
          case 4:
            return CupertinoTabView(
                builder: (context) => const ProfileScreen());
          default:
            return CupertinoTabView(builder: (context) => const SearchScreen());
        }
      },
    );
  }
}
