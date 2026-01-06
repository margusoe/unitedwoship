class Song {
  final int id;
  final String title;
  final String songkey;
  final String songxml;
  final String author;
  final String youtubeLink;

  Song({
    required this.id,
    required this.title,
    required this.songkey,
    required this.songxml,
    required this.author,
    required this.youtubeLink,
  });

  // --- 1. JSON Parsing (From Assets) ---
  factory Song.fromJson(Map<String, dynamic> json) {
    // Extract Youtube
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

    // Extract Author (from 'I' list where z == 'wordsandmusic' or 'author')
    String author = '';
    if (json['I'] != null && json['I'] is List) {
      for (var item in json['I']) {
        if (item['z'] == 'wordsandmusic' || item['z'] == 'author') {
          author = item['v'] ?? '';
          break;
        }
      }
    }

    // Helper to remove XML entities
    String cleanString(String? input) {
      if (input == null) return '';
      // Replaces "&amp;" with "&".
      // If your chords use "&" as a Flat symbol, change the second argument to "b"
      // e.g. input.replaceAll('&amp;', 'b');
      return input.replaceAll('&amp;', 'b');
    }

    return Song(
      id: json['i'] ?? 0,
      title: cleanString(json['8']),
      songkey: cleanString(json['k']),
      songxml: cleanString(json['x']),
      author: cleanString(author),
      youtubeLink: youtubeLink,
    );
  }

  // --- 2. Database Mapping (To/From SQLite) ---

  // Create object from DB Map
  factory Song.fromDb(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      songkey: map['song_key'] ?? '',
      songxml: map['song_xml'] ?? '',
      author: map['author'] ?? '',
      youtubeLink: map['youtube_link'] ?? '',
    );
  }

  // Convert object to DB Map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'song_key': songkey,
      'song_xml': songxml,
      'author': author,
      'youtube_link': youtubeLink,
    };
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title, songkey: $songkey, author: $author, youtubeLink: $youtubeLink, songxml: $songxml)';
  }
}
