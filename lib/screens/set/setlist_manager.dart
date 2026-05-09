import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart';

class SetlistManager extends ChangeNotifier {
  final pb = getIt<PocketBaseService>().pb;

  List<Setlist> setlists = [];
  bool isLoading = false;

  String get currentUserId => pb.authStore.model?.id ?? "";

  Future<void> fetchSetlists() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch setlists where the user is EITHER the owner OR a subscriber
      final records = await pb.collection('setlists').getFullList(
            filter:
                'owner = "$currentUserId" || subscribers ~ "$currentUserId"',
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

  Future<void> createSetlist(String title, DateTime date) async {
    try {
      await pb.collection('setlists').create(body: {
        'title': title,
        'scheduled_date': date.toUtc().toIso8601String(),
        'owner': currentUserId, // Set the creator as the owner
      });
      await fetchSetlists();
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
      await fetchSetlists();
    } catch (e) {
      debugPrint("Update Setlist Error: $e");
      rethrow;
    }
  }

  Future<void> deleteSetlist(String id) async {
    try {
      await pb.collection('setlists').delete(id);
      await fetchSetlists();
    } catch (e) {
      debugPrint("Delete Setlist Error: $e");
      rethrow;
    }
  }

  // --- NEW: JOIN SETLIST LOGIC ---
  Future<void> joinSetlist(String setlistId) async {
    try {
      // 1. Fetch the setlist to get current subscribers
      final setlist = await pb.collection('setlists').getOne(setlistId);

      // 2. Add current user to subscribers list (if not already there)
      List<String> subscribers =
          List<String>.from(setlist.getListValue('subscribers'));
      if (!subscribers.contains(currentUserId)) {
        subscribers.add(currentUserId);

        // 3. Update PocketBase
        await pb.collection('setlists').update(setlistId, body: {
          'subscribers': subscribers,
        });
      }

      await fetchSetlists(); // Refresh list to show the joined setlist
    } catch (e) {
      debugPrint("Join Setlist Error: $e");
      throw Exception("Invalid Setlist Code or it has been deleted.");
    }
  }
}
