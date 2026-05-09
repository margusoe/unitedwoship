import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/setlist_models.dart';
import 'package:unitedwoship/screens/set/setlist_detail_screen.dart';
import 'package:unitedwoship/screens/set/setlist_manager.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final setlistManager = getIt<SetlistManager>();

  @override
  void initState() {
    super.initState();
    setlistManager.fetchSetlists();
  }

  // Dialog for both Creating and Updating a Setlist
  void _showSetlistDialog({Setlist? existingSetlist}) {
    final isEditing = existingSetlist != null;
    final titleController =
        TextEditingController(text: existingSetlist?.title ?? '');
    DateTime selectedDate = existingSetlist?.scheduledDate ?? DateTime.now();

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(isEditing ? 'Edit Setlist' : 'New Setlist'),
          content: Column(
            children: [
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: titleController,
                placeholder: 'Setlist Title (e.g. Sunday Service)',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;

                Navigator.pop(context); // Close dialog

                if (isEditing) {
                  await setlistManager.updateSetlist(existingSetlist.id,
                      titleController.text.trim(), selectedDate);
                } else {
                  await setlistManager.createSetlist(
                      titleController.text.trim(), selectedDate);
                }
              },
              child: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  void _showJoinDialog() {
    final codeController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Join Setlist'),
          content: Column(
            children: [
              const SizedBox(height: 8),
              const Text('Enter the Setlist Code shared by the leader.'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: codeController,
                placeholder: 'Paste Code Here',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                final code = codeController.text.trim();
                if (code.isEmpty) return;

                Navigator.pop(context); // Close dialog

                try {
                  await setlistManager.joinSetlist(code);
                } catch (e) {
                  if (context.mounted) {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: const Text('Error'),
                        content:
                            Text(e.toString().replaceAll('Exception: ', '')),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(ctx),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

  // Action Sheet for Edit/Delete
  void _showOptionsSheet(Setlist setlist) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(setlist.title),
        message: const Text('What would you like to do?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showSetlistDialog(existingSetlist: setlist);
            },
            child: const Text('Edit Setlist'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await setlistManager.deleteSetlist(setlist.id);
            },
            child: const Text('Delete Setlist'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: setlistManager,
      builder: (context, _) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Setlists'),
            // Replaced the single + icon with a row of two buttons
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showJoinDialog,
                  child: const Icon(CupertinoIcons.person_add), // Join icon
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showSetlistDialog(),
                  child: const Icon(CupertinoIcons.add), // Create icon
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: setlistManager.isLoading && setlistManager.setlists.isEmpty
                ? const Center(child: CupertinoActivityIndicator())
                : setlistManager.setlists.isEmpty
                    ? const Center(child: Text("No setlists found."))
                    : ListView.builder(
                        itemCount: setlistManager.setlists.length,
                        itemBuilder: (context, i) {
                          final setlist = setlistManager.setlists[i];
                          // Format date for display
                          final dateText = DateFormat('MMM d, yyyy')
                              .format(setlist.scheduledDate);

                          // Replace your existing CupertinoListTile with this wrapped version:

                          return GestureDetector(
                            onLongPress: () => _showOptionsSheet(setlist),
                            child: CupertinoListTile(
                              title: Text(setlist.title),
                              subtitle: Text(dateText),
                              trailing: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoColors.systemGrey4),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => SetlistDetailScreen(
                                      setlistId: setlist.id,
                                      setlistTitle: setlist.title,
                                      // Setlist models need to expose the owner,
                                      // For now you can just grab it directly if your model supports it:
                                      ownerId: setlist
                                          .owner, // <-- We need to add this to Setlist Model!
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }
}
