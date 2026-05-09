// lib/infrastructure/setlist_models.dart
import 'package:pocketbase/pocketbase.dart';

class Setlist {
  final String id;
  final String title;
  final DateTime scheduledDate;
  final String? liveCurrentItemId;
  final String owner;

  Setlist({
    required this.id,
    required this.title,
    required this.scheduledDate,
    required this.owner,
    this.liveCurrentItemId,
  });

  factory Setlist.fromRecord(RecordModel record) {
    return Setlist(
      id: record.id,
      title: record.getStringValue('title'),
      scheduledDate: DateTime.parse(record.getStringValue('scheduled_date')),
      liveCurrentItemId: record.getStringValue('live_current_item_id'),
      owner: record.getStringValue('owner'),
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
