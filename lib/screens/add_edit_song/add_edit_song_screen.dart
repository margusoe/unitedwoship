import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/screens/add_edit_song/add_edit_song_manager.dart';

class AddEditSongScreen extends StatefulWidget {
  const AddEditSongScreen({
    super.key,
    this.songId,
  });

  final int? songId;
  @override
  State<AddEditSongScreen> createState() => _AddEditSongScreenState();
}

class _AddEditSongScreenState extends State<AddEditSongScreen> {
  final _manager = AddEditSongManager();
  final TextEditingController _lyricsController = TextEditingController();
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _composerController = TextEditingController();
  final TextEditingController _lyricAuthorController = TextEditingController();
  final List<String> _chords = [
    'A',
    'Am',
    'A7',
    'Am7',
    'B',
    'Bm',
    'B7',
    'Bm7',
    'C',
    'Cm',
    'C7',
    'Cm7',
    'D',
    'Dm',
    'D7',
    'Dm7',
    'E',
    'Em',
    'E7',
    'Em7',
    'F',
    'Fm',
    'F7',
    'Fm7',
    'G',
    'Gm',
    'G7',
    'Gm7',
  ];

  @override
  void initState() {
    super.initState();
    _populateTextFields();
  }

  Future<void> _populateTextFields() async {
    final songModel = await _manager.getSongModel(widget.songId);
    if (songModel == null) return;
    _lyricsController.text = songModel.lyrics;
    _songNameController.text = songModel.title;
    _composerController.text = songModel.composer;
    _lyricAuthorController.text = songModel.lyricAuthor;
  }

  @override
  void dispose() {
    _lyricsController.dispose();
    _songNameController.dispose();
    _composerController.dispose();
    _lyricAuthorController.dispose();
    super.dispose();
  }

  void _insertChord(String chord) {
    final bracketedChord = '[$chord]';
    final text = _lyricsController.text;
    final selection = _lyricsController.selection;
    final newText =
        text.replaceRange(selection.start, selection.end, bracketedChord);
    final newSelection = TextSelection.collapsed(
        offset: selection.start + bracketedChord.length);

    _lyricsController.value = TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }

  void _saveSong() {
    if (_lyricsController.text.isNotEmpty &&
        _songNameController.text.isNotEmpty &&
        _composerController.text.isNotEmpty &&
        _lyricAuthorController.text.isNotEmpty) {
      _manager.saveSong(
        songId: widget.songId,
        songName: _songNameController.text,
        composer: _composerController.text,
        lyricAuthor: _lyricAuthorController.text,
        lyrics: _lyricsController.text,
      );
      Navigator.pop(context, _lyricsController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.songId == null ? Text('Add Song') : Text('Edit Song'),
        actions: [
          PopupMenuButton<String>(
            icon: const Text("Choose chords..."),
            itemBuilder: (context) => _chords.map((String chord) {
              return PopupMenuItem<String>(
                value: chord,
                child: Text(chord),
              );
            }).toList(),
            onSelected: _insertChord,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSong,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _songNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Song Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _composerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Composer',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lyricAuthorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lyric Author',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _lyricsController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your lyrics here...',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
