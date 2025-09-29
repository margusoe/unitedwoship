import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

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
  // AppStateManager is still needed to provide the theme for the root CupertinoApp
  // and for any direct state management, but theme properties are accessed via context.
  final appstatemanager = getIt<AppStateManager>();

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
    // We no longer need isDarkMode here to pick styles, as AppTheme methods handle it.
    // final isDarkMode = getIt<UserSettings>().getDarkMode(); // No longer directly used for styling
    // final theme = appstatemanager.theme; // This is the full CupertinoThemeData for the app.

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add Song'),
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
                    Text(
                      'Song Title',
                      style: AppTheme.titleStyle(context), // <--- Refactored
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _songTitleController,
                      placeholder: 'Enter song title',
                      style: AppTheme.bodyStyle(context), // <--- Refactored
                      placeholderStyle:
                          AppTheme.hintStyle(context), // <--- Refactored
                      decoration: AppTheme.textFieldDecoration(
                          context), // <--- Refactored
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lyrics',
                      style: AppTheme.titleStyle(context), // <--- Refactored
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _lyricsController,
                      placeholder: 'Enter lyrics \n\n\n\n',
                      minLines: 5,
                      maxLines: null,
                      style: AppTheme.bodyStyle(context), // <--- Refactored
                      placeholderStyle:
                          AppTheme.hintStyle(context), // <--- Refactored
                      decoration: AppTheme.textFieldDecoration(
                          context), // <--- Refactored
                      padding: const EdgeInsets.all(12.0),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Author',
                      style: AppTheme.titleStyle(context), // <--- Refactored
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _authorController,
                      placeholder: 'Enter author',
                      style: AppTheme.bodyStyle(context), // <--- Refactored
                      placeholderStyle:
                          AppTheme.hintStyle(context), // <--- Refactored
                      decoration: AppTheme.textFieldDecoration(
                          context), // <--- Refactored
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Melody Author',
                      style: AppTheme.titleStyle(context), // <--- Refactored
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _melodyAuthorController,
                      placeholder: 'Enter melody author',
                      style: AppTheme.bodyStyle(context), // <--- Refactored
                      placeholderStyle:
                          AppTheme.hintStyle(context), // <--- Refactored
                      decoration: AppTheme.textFieldDecoration(
                          context), // <--- Refactored
                      padding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'YouTube Link',
                      style: AppTheme.titleStyle(context), // <--- Refactored
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: _youtubeLinkController,
                      placeholder: 'Enter YouTube link',
                      style: AppTheme.bodyStyle(context), // <--- Refactored
                      placeholderStyle:
                          AppTheme.hintStyle(context), // <--- Refactored
                      decoration: AppTheme.textFieldDecoration(
                          context), // <--- Refactored
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
                height: 40,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppTheme.primaryColor(context), // <--- Refactored
                  borderRadius: BorderRadius.circular(4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: AppTheme.onPrimaryColor(
                              context), // <--- Refactored
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
