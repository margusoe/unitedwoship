import 'package:flutter/material.dart';
import 'package:unitedwoship/screens/add_song/add_song_manager.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _manager = AddSongManager();
  final TextEditingController _textController = TextEditingController();
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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _insertChord(String chord) {
    final bracketedChord = '[$chord]';
    final text = _textController.text;
    final selection = _textController.selection;
    final newText =
        text.replaceRange(selection.start, selection.end, bracketedChord);
    final newSelection = TextSelection.collapsed(
        offset: selection.start + bracketedChord.length);

    _textController.value = TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }

  void _saveSong() {
    if (_textController.text.isNotEmpty) {
      _manager.addSong(
        songName: "songName",
        composer: "composer",
        lyricAuthor: "lyricAuthor",
        originalKey: "originalKey",
        lyrics: _textController.text,
      );
      Navigator.pop(context, _textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
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
        child: TextField(
          controller: _textController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your text here...',
          ),
        ),
      ),
    );
  }
}
