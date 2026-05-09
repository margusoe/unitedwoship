import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart';

class SetlistManager extends ChangeNotifier {
  final pb = getIt<PocketBaseService>().pb;

  List<Setlist> setlists = [];
  bool isLoading = false;

  Future<void> fetchSetlists() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch setlists, sorted by scheduled date
      final records = await pb.collection('setlists').getFullList(
            sort: '-scheduled_date',
          );
      setlists = records.map((r) => Setlist.fromRecord(r)).toList();
    } catch (e) {
      debugPrint("Failed fetching setlists: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSetlist(String title, DateTime date,
      {String? teamId}) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'scheduled_date': date.toUtc().toIso8601String(),
      };

      // Only attach a team if they selected one (for now, it remains personal)
      if (teamId != null && teamId.isNotEmpty) {
        body['team_id'] = teamId;
      }

      await pb.collection('setlists').create(body: body);
      await fetchSetlists(); // Refresh list
    } catch (e) {
      debugPrint("Create Setlist Error: $e");
      rethrow;
    }
  }

  Future<void> updateSetlist(String id, String title, DateTime date) async {
    try {
      await pb.collection('setlists').update(id, body: {
        'title': title,
        'scheduled_date': date.toUtc().toIso8601String(),
      });
      await fetchSetlists(); // Refresh list
    } catch (e) {
      debugPrint("Update Setlist Error: $e");
      rethrow;
    }
  }

  Future<void> deleteSetlist(String id) async {
    try {
      await pb.collection('setlists').delete(id);
      await fetchSetlists(); // Refresh list
    } catch (e) {
      debugPrint("Delete Setlist Error: $e");
      rethrow;
    }
  }
}
