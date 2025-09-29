import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/add/add_screen.dart';
import 'package:unitedwoship/screens/favorites/favorites_screen.dart';
import 'package:unitedwoship/screens/settings/settings_screen.dart';
import 'package:unitedwoship/screens/search/search_screen.dart';
import 'package:unitedwoship/screens/set/set_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appstatemanager = getIt<AppStateManager>();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: AppTheme.primaryColor(context),
        inactiveColor: AppTheme.secondaryColor(context),
        backgroundColor: AppTheme.backgroundColor(context),
        border: null,
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
              CupertinoIcons.settings,
              size: 20,
            ),
            label: 'Settings',
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
                builder: (context) => const SettingsScreen());
          default:
            return CupertinoTabView(builder: (context) => const SearchScreen());
        }
      },
    );
  }
}
