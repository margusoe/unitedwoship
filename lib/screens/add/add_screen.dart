
import 'package:flutter/cupertino.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _songTitleController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _authorController = TextEditingController();
  final _melodyAuthorController = TextEditingController();
  final _youtubeLinkController = TextEditingController();

  @override
  void dispose() {
    _songTitleController.dispose();
    _lyricsController.dispose();
    _authorController.dispose();
    _melodyAuthorController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Add Song'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark, size: 24),
          onPressed: () {
            // TODO: Implement close functionality
          },
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('Song Title', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _songTitleController,
                placeholder: 'Enter song title',
              ),
              const SizedBox(height: 16),
              const Text('Lyrics', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _lyricsController,
                placeholder: 'Enter lyrics',
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              const Text('Author', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _authorController,
                placeholder: 'Enter author',
              ),
              const SizedBox(height: 16),
              const Text('Melody Author', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _melodyAuthorController,
                placeholder: 'Enter melody author',
              ),
              const SizedBox(height: 16),
              const Text('YouTube Link', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _youtubeLinkController,
                placeholder: 'Enter YouTube link',
              ),
              const SizedBox(height: 32),
              CupertinoButton.filled(
                child: const Text('Submit'),
                onPressed: () {
                  // TODO: Implement submit functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
