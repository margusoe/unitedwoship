import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class LiveModeManager {
  final _pb = getIt<PocketBaseService>().pb;

  // Notifies the UI to switch to a specific setlist_item_idssssss
  final ValueNotifier<String?> activeItemId = ValueNotifier<String?>(null);

  void subscribeToSetlist(String setlistId) {
    _pb.collection('setlists').subscribe(setlistId, (e) {
      if (e.action == 'update') {
        activeItemId.value = e.record?.getStringValue('live_current_item_id');
      }
    });
  }

  void unsubscribe() {
    _pb.collection('setlists').unsubscribe();
  }

  // Called by the "Leader" to change the song
  Future<void> setLiveItem(String setlistId, String itemId) async {
    await _pb.collection('setlists').update(setlistId, body: {
      'live_current_item_id': itemId,
    });
  }
}
