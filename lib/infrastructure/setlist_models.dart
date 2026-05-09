// lib/infrastructure/setlist_models.dart
import 'package:pocketbase/pocketbase.dart';

class Setlist {
  final String id;
  final String title;
  final DateTime scheduledDate; // Added back
  final String? liveCurrentItemId;

  Setlist(
      {required this.id,
      required this.title,
      required this.scheduledDate,
      this.liveCurrentItemId});

  factory Setlist.fromRecord(RecordModel record) {
    return Setlist(
      id: record.id,
      title: record.getStringValue('title'),
      // PocketBase dates come as strings (e.g., "2023-10-27 10:00:00.000Z")
      scheduledDate: DateTime.parse(record.getStringValue('scheduled_date')),
      liveCurrentItemId: record.getStringValue('live_current_item_id'),
    );
  }
}

class SetlistItem {
  final String id;
  final String songId;
  final String selectedKey;
  final int capo;
  final int sortOrder;

  SetlistItem(
      {required this.id,
      required this.songId,
      required this.selectedKey,
      required this.capo,
      required this.sortOrder});

  factory SetlistItem.fromRecord(RecordModel record) {
    return SetlistItem(
      id: record.id,
      songId: record.getStringValue('song_id'),
      selectedKey: record.getStringValue('selected_key'),
      capo: record.getIntValue('capo'),
      sortOrder: record.getIntValue('sort_order'),
    );
  }
}
