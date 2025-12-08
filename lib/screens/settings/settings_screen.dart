import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/screens/about/about_screen.dart';
import 'package:unitedwoship/screens/settings/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  int _selectedTheme = 0; // 0 for light, 1 for dark

  final userSettings = getIt<UserSettings>();
  final settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _selectedTheme = userSettings.getDarkMode() ? 1 : 0;
    _fontSize = userSettings.getFontSize();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTheme.titleStyle(context);
    final hintStyle = AppTheme.hintStyle(context);

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: userSettings.userName,
                      builder: (context, name, child) {
                        return Text(
                          name,
                          style: titleStyle.copyWith(fontSize: 24),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoListTile(
                  title: Text('Name', style: titleStyle),
                  additionalInfo: Icon(CupertinoIcons.pencil),
                  onTap: () => _showEditNameDialog(context),
                ),
                CupertinoListTile(
                    title: Text('Appearance', style: titleStyle),
                    additionalInfo: CupertinoSlidingSegmentedControl<int>(
                      children: const {
                        0: Text('Light'),
                        1: Text('Dark'),
                      },
                      groupValue: _selectedTheme,
                      onValueChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedTheme = value;
                          getIt<AppStateManager>().setDarkMode(value == 1);
                        });
                      },
                    )),
                CupertinoListTile(
                  title: Text('Language', style: titleStyle),
                  additionalInfo: Text('English', style: hintStyle),
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                CupertinoListTile(
                  title: Text('Font Size', style: titleStyle),
                  additionalInfo:
                      Text(_fontSize.toStringAsFixed(0), style: hintStyle),
                  subtitle: CupertinoSlider(
                    thumbColor: AppTheme.primaryColor(context),
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                        settingsManager.dragFontSize(value);
                      });
                    },
                  ),
                ),
                CupertinoListTile(
                  title: Text('About', style: titleStyle),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController textController =
        TextEditingController(text: userSettings.getUserName());
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Enter your name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Save'),
              onPressed: () {
                settingsManager.setUserName(textController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
