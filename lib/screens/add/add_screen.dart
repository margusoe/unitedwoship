
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
    const Color darkBlue = Color(0xFF101823);
    const Color textFieldColor = Color(0xFF1B2531);
    const Color lightBlue = Color(0xFF7EB6FD);

    const TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFECECED),
    );

    const TextStyle textStyle = TextStyle(color: Color(0xFFECECED));
    const TextStyle placeholderStyle = TextStyle(color: Color(0xFF87A2C6));

    const BoxDecoration textFieldDecoration = BoxDecoration(
      color: textFieldColor,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    );

    return CupertinoPageScaffold(
      backgroundColor: darkBlue,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: darkBlue,
        border: null,
        middle: const Text('Add Song', style: TextStyle(color: Color(0xFFECECED))),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark, color: Color(0xFFECECED), size: 24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                    const Text('Song Title', style: labelStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _songTitleController,
                      placeholder: 'Enter song title',
                      style: textStyle,
                      placeholderStyle: placeholderStyle,
                      decoration: textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('Lyrics', style: labelStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _lyricsController,
                      placeholder: 'Enter lyrics',
                      maxLines: 5,
                      style: textStyle,
                      placeholderStyle: placeholderStyle,
                      decoration: textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('Author', style: labelStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _authorController,
                      placeholder: 'Enter author',
                      style: textStyle,
                      placeholderStyle: placeholderStyle,
                      decoration: textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('Melody Author', style: labelStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _melodyAuthorController,
                      placeholder: 'Enter melody author',
                      style: textStyle,
                      placeholderStyle: placeholderStyle,
                      decoration: textFieldDecoration,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    const Text('YouTube Link', style: labelStyle),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _youtubeLinkController,
                      placeholder: 'Enter YouTube link',
                      style: textStyle,
                      placeholderStyle: placeholderStyle,
                      decoration: textFieldDecoration,
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
                child: CupertinoButton(
                  color: lightBlue,
                  child: const Text('Submit', style: TextStyle(color: Color(0xFF162432))),
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
