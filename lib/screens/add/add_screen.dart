import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';

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
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text('Song Title', style: AppTheme.titleStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _songTitleController,
                      placeholder: 'Enter song title',
                      style: AppTheme.bodyStyle,
                      placeholderStyle: AppTheme.hintStyle,
                      decoration: AppTheme.textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('Lyrics', style: AppTheme.titleStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _lyricsController,
                      placeholder: 'Enter lyrics',
                      maxLines: 5,
                      style: AppTheme.bodyStyle,
                      placeholderStyle: AppTheme.hintStyle,
                      decoration: AppTheme.textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                    const SizedBox(height: 16),
                    const Text('Author', style: AppTheme.titleStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _authorController,
                      placeholder: 'Enter author',
                      style: AppTheme.bodyStyle,
                      placeholderStyle: AppTheme.hintStyle,
                      decoration: AppTheme.textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('Melody Author', style: AppTheme.titleStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _melodyAuthorController,
                      placeholder: 'Enter melody author',
                      style: AppTheme.bodyStyle,
                      placeholderStyle: AppTheme.hintStyle,
                      decoration: AppTheme.textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('YouTube Link', style: AppTheme.titleStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _youtubeLinkController,
                      placeholder: 'Enter YouTube link',
                      style: AppTheme.bodyStyle,
                      placeholderStyle: AppTheme.hintStyle,
                      decoration: AppTheme.textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 40, // Explicitly set height to 40px
                child: CupertinoButton(
                  padding:
                      EdgeInsets.zero, // Remove default padding to fit height
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: AppTheme.onPrimaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement submit functionality
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
