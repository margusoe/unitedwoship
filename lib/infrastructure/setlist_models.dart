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
      scheduledDate:
          DateTime.parse(record.getStringValue('scheduled_date')).toLocal(),
      liveCurrentItemId: record.getStringValue('live_current_item_id'),
      owner: record.getStringValue('owner'),
    );
  }

  // --- NEW: From SQLite ---
  factory Setlist.fromDb(Map<String, dynamic> map) {
    return Setlist(
      id: map['id'],
      title: map['title'],
      scheduledDate: DateTime.parse(map['scheduled_date']).toLocal(),
      liveCurrentItemId: map['live_current_item_id'],
      owner: map['owner'],
    );
  }

  // --- NEW: To SQLite ---
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'scheduled_date': scheduledDate.toUtc().toIso8601String(),
      'live_current_item_id': liveCurrentItemId,
      'owner': owner,
    };
  }
}

class SetlistItem {
  final String id;
  final String setlistId; // Added this
  final String songId;
  final String selectedKey;
  final int capo;
  final int sortOrder;

  SetlistItem({
    required this.id,
    required this.setlistId,
    required this.songId,
    required this.selectedKey,
    required this.capo,
    required this.sortOrder,
  });

  factory SetlistItem.fromRecord(RecordModel record) {
    return SetlistItem(
      id: record.id,
      setlistId: record.getStringValue('setlist_id'),
      songId: record.getStringValue('song_id'),
      selectedKey: record.getStringValue('selected_key'),
      capo: record.getIntValue('capo'),
      sortOrder: record.getIntValue('sort_order'),
    );
  }

  // --- NEW: From SQLite ---
  factory SetlistItem.fromDb(Map<String, dynamic> map) {
    return SetlistItem(
      id: map['id'],
      setlistId: map['setlist_id'],
      songId: map['song_id'],
      selectedKey: map['selected_key'],
      capo: map['capo'],
      sortOrder: map['sort_order'],
    );
  }

  // --- NEW: To SQLite ---
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'setlist_id': setlistId,
      'song_id': songId,
      'selected_key': selectedKey,
      'capo': capo,
      'sort_order': sortOrder,
    };
  }
}
