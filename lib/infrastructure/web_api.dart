import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WebApi {
  late List<Song> songs;
  Song getSong(int songId) {
    return songs.firstWhere((song) => song.id == songId);
  }

  // Function to load and parse the JSON from assets
  Future<void> loadSongs() async {
    // Load the JSON string from the asset file
    final String jsonString = await rootBundle.loadString('assets/dbmn.json');

    // Decode the JSON string into a Map
    final Map<String, dynamic> parsedJson = json.decode(jsonString);

    // Get the list of song data
    final List<dynamic> songListJson = parsedJson['data'];

    // Map the list of JSON objects to a list of Song objects
    songs = songListJson.map((json) => Song.fromJson(json)).toList();
  }
}

class Song {
  final List<String> alternativeTitles;
  final int id;
  final String title;
  final String songkey;
  final String songxml;
  final List<SongInfo> info;
  final String youtubeLink;

  Song(
      {required this.alternativeTitles,
      required this.id,
      required this.title,
      required this.songkey,
      required this.songxml,
      required this.info,
      required this.youtubeLink});

  factory Song.fromJson(Map<String, dynamic> json) {
    String youtubeLink = '';
    if (json['f'] != null && json['f'] is List) {
      for (var mediaItem in json['f']) {
        if (mediaItem is Map<String, dynamic> &&
            mediaItem['Z'] != null &&
            mediaItem['Z']['type'] == 'youtube') {
          youtubeLink = mediaItem['p'] ?? '';
          break;
        }
      }
    }
    if (youtubeLink == '') {
      print(json['8']);
    }

    return Song(
      alternativeTitles: json['A'] != null ? List<String>.from(json['A']) : [],
      id: json['i'] ?? 0,
      title: json['8'] ?? '',
      songkey: json['k'] ?? '',
      songxml: json['x'] ?? '',
      info: json['I'] != null
          ? (json['I'] as List).map((i) => SongInfo.fromJson(i)).toList()
          : [],
      youtubeLink: youtubeLink,
    );
  }
}

class SongInfo {
  final String value;
  final String type;

  SongInfo({required this.value, required this.type});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      value: json['v'] ?? '',
      type: json['z'] ?? '',
    );
  }
}
