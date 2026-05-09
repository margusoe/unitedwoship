import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart';
import 'package:unitedwoship/screens/set/setlist_detail_screen.dart';

class SetScreen extends StatelessWidget {
  const SetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pb = getIt<PocketBaseService>().pb;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Setlists')),
      child: FutureBuilder(
        future: pb.collection('setlists').getFullList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CupertinoActivityIndicator());
          final setlists =
              snapshot.data!.map((r) => Setlist.fromRecord(r)).toList();

          return ListView.builder(
            itemCount: setlists.length,
            itemBuilder: (context, i) => CupertinoListTile(
              title: Text(setlists[i].title),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SetlistDetailScreen(
                      setlistId: setlists[i].id,
                      setlistTitle: setlists[i].title,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
