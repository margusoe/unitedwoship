import 'package:flutter/cupertino.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CupertinoSearchTextField(),
            SizedBox(height: 20),
            Text(
              'Find all the best worship songs, artists and albums. All in one place',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: CupertinoColors.white),
            ),
          ],
        ),
      ),
    );
  }
}