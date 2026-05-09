// lib/infrastructure/song.dart
import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class Song {
  final String id;
  final String title;
  final List<String> authors;
  final String originalKey;
  final String lyrics; // Replaces songxml
  final String mediaLink; // Replaces youtubeLink
  final int tempoBpm;
  final String timeSignature;
  final List<String> themes;
  final String approvalStatus;
  final DateTime updated; // Crucial for offline sync

  Song({
    required this.id,
    required this.title,
    required this.authors,
    required this.originalKey,
    required this.lyrics,
    required this.mediaLink,
    required this.tempoBpm,
    required this.timeSignature,
    required this.themes,
    required this.approvalStatus,
    required this.updated,
  });

  // --- 1. Parse from PocketBase Record ---
  factory Song.fromRecord(RecordModel record) {
    return Song(
      id: record.id,
      title: record.getStringValue('title'),
      authors: _parseStringList(record.getListValue<String>('authors')),
      originalKey: record.getStringValue('original_key'),
      lyrics: record.getStringValue('lyrics'),
      mediaLink: record.getStringValue('media_link'),
      tempoBpm: record.getIntValue('tempo_bpm'),
      timeSignature: record.getStringValue('time_signature'),
      themes: _parseStringList(record.getListValue<String>('themes')),
      approvalStatus: record.getStringValue('approval_status'),
      updated: DateTime.parse(record.updated).toLocal(),
    );
  }

  // --- 2. Parse from SQLite ---
  factory Song.fromDb(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      authors: List<String>.from(jsonDecode(map['authors'] ?? '[]')),
      originalKey: map['original_key'] ?? '',
      lyrics: map['lyrics'] ?? '',
      mediaLink: map['media_link'] ?? '',
      tempoBpm: map['tempo_bpm'] ?? 0,
      timeSignature: map['time_signature'] ?? '',
      themes: List<String>.from(jsonDecode(map['themes'] ?? '[]')),
      approvalStatus: map['approval_status'] ?? 'approved',
      updated: DateTime.parse(map['updated']).toLocal(),
    );
  }

  // --- 3. Convert to SQLite Map ---
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'authors': jsonEncode(authors),
      'original_key': originalKey,
      'lyrics': lyrics,
      'media_link': mediaLink,
      'tempo_bpm': tempoBpm,
      'time_signature': timeSignature,
      'themes': jsonEncode(themes),
      'approval_status': approvalStatus,
      'updated': updated.toUtc().toIso8601String(),
    };
  }

  static List<String> _parseStringList(List<dynamic> list) {
    return list.map((e) => e.toString()).toList();
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title)';
  }
}
