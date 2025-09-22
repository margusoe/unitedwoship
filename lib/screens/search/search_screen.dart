import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final appstatemanager = getIt<AppStateManager>();
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
            Text(
              'Find all the best worship songs, artists and albums. All in one place',
              textAlign: TextAlign.center,
              style: theme.textTheme.textStyle.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
