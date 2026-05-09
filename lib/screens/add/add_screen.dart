// lib/screens/add/add_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _songTitleController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _authorController = TextEditingController();
  final _melodyAuthorController = TextEditingController();
  final _youtubeLinkController = TextEditingController();

  bool _isLoading = false; // Added loading state

  @override
  void dispose() {
    _songTitleController.dispose();
    _lyricsController.dispose();
    _authorController.dispose();
    _melodyAuthorController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  }

  // Inside _AddScreenState

  Future<void> _submit() async {
    final title = _songTitleController.text.trim();
    final lyrics = _lyricsController.text.trim();
    final author = _authorController.text.trim();

    if (title.isEmpty) {
      _showDialog('Validation Error', 'Song title cannot be empty.');
      return;
    }
    if (lyrics.isEmpty) {
      _showDialog('Validation Error', 'Please enter some lyrics.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pb = getIt<PocketBaseService>().pb;
      final db = getIt<SongDatabase>();

      List<String> authors = [];
      if (author.isNotEmpty) authors.add(author);
      if (_melodyAuthorController.text.trim().isNotEmpty) {
        authors.add(_melodyAuthorController.text.trim());
      }

      // 1. Send to PocketBase as "pending" (Pending on server)
      final record = await pb.collection('songs').create(body: {
        'title': title,
        'lyrics': lyrics,
        'authors': authors,
        'original_key': 'C',
        'tempo_bpm': 120,
        'time_signature': '4/4',
        'media_link': _youtubeLinkController.text.trim(),
        'approval_status': 'pending', // <--- Set to Pending
        'themes': [],
      });

      // 2. Add to local SQLite DB instantly so it's usable right away
      final newSong = Song.fromRecord(record);
      await db.insertBatch([newSong]);

      if (!mounted) return;

      _songTitleController.clear();
      _lyricsController.clear();
      _authorController.clear();
      _melodyAuthorController.clear();
      _youtubeLinkController.clear();

      _showDialog(
          'Success', 'Song added locally and is pending server approval!');
    } on ClientException catch (e) {
      debugPrint('PB Error: ${e.response}');
      _showDialog(
          'Error', 'Failed to connect to the server. Please try again.');
    } catch (e) {
      debugPrint('Error: $e');
      _showDialog('Error', 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add Song'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text('Song Title *', style: AppTheme.titleStyle(context)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _songTitleController,
                    placeholder: 'Enter song title',
                    style: AppTheme.bodyStyle(context),
                    placeholderStyle: AppTheme.hintStyle(context),
                    decoration: AppTheme.textFieldDecoration(context),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  Text('Lyrics *', style: AppTheme.titleStyle(context)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _lyricsController,
                    placeholder:
                        '[Verse]\nEnter lyrics here...\n\n[Chorus]\n...',
                    minLines: 8,
                    maxLines: null,
                    style: AppTheme.bodyStyle(context),
                    placeholderStyle: AppTheme.hintStyle(context),
                    decoration: AppTheme.textFieldDecoration(context),
                    padding: const EdgeInsets.all(12.0),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                  const SizedBox(height: 16),
                  Text('Author', style: AppTheme.titleStyle(context)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _authorController,
                    placeholder: 'Enter author',
                    style: AppTheme.bodyStyle(context),
                    placeholderStyle: AppTheme.hintStyle(context),
                    decoration: AppTheme.textFieldDecoration(context),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  Text('Melody Author', style: AppTheme.titleStyle(context)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _melodyAuthorController,
                    placeholder: 'Enter melody author',
                    style: AppTheme.bodyStyle(context),
                    placeholderStyle: AppTheme.hintStyle(context),
                    decoration: AppTheme.textFieldDecoration(context),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  Text('YouTube Link', style: AppTheme.titleStyle(context)),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _youtubeLinkController,
                    placeholder: 'Enter YouTube or Media link',
                    style: AppTheme.bodyStyle(context),
                    placeholderStyle: AppTheme.hintStyle(context),
                    decoration: AppTheme.textFieldDecoration(context),
                    padding: const EdgeInsets.all(12.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppTheme.primaryColor(context),
                  borderRadius: BorderRadius.circular(8),
                  onPressed: _isLoading ? null : _submit, // Disable if loading
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : Text(
                          'Submit Song',
                          style: TextStyle(
                              color: AppTheme.onPrimaryColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
