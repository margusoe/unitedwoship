import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  int _selectedTheme = 0; // 0 for light, 1 for dark

  final userSettings = getIt<UserSettings>();

  @override
  void initState() {
    super.initState();
    _selectedTheme = userSettings.getDarkMode() ? 1 : 0;
    _fontSize = userSettings.getFontSize();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _selectedTheme == 1;
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    final titleStyle = AppTheme.titleStyle(context);
    final hintStyle = AppTheme.hintStyle(context);
    final surfaceColor = AppTheme.surfaceColor(context);
    final secondaryTextColor = AppTheme.secondaryColor(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: surfaceColor,
                  ),
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: secondaryTextColor,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ethan Clark',
                  style: titleStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'ethan.clark@email.com',
                  style: hintStyle,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoListTile(
                  title: Text('Edit Profile', style: titleStyle),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: Text('Language', style: titleStyle),
                  additionalInfo: Text('English', style: hintStyle),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: Text('Font Size', style: titleStyle),
                  additionalInfo:
                      Text(_fontSize.toStringAsFixed(0), style: hintStyle),
                  subtitle: CupertinoSlider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                        userSettings.setFontSize(value);
                      });
                    },
                  ),
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
                        setState(() {
                          _selectedTheme = value!;
                          userSettings.setDarkMode(value == 1);
                        });
                      },
                    )),
                CupertinoListTile(
                  title: Text('About', style: titleStyle),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
