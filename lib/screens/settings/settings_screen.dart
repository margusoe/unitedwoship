import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  int _selectedTheme = 0; // 0 for light, 1 for dark

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceColor,
                  ),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: AppTheme.secondaryTextColor,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ethan Clark',
                  style: AppTheme.titleStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ethan.clark@email.com',
                  style: AppTheme.hintStyle,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoListTile(
                  title: const Text('Edit Profile'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: const Text('Language'),
                  additionalInfo: const Text('English'),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: const Text('Font size'),
                  additionalInfo: const Text('20'),
                  onTap: () {},
                ),
                CupertinoListTile(
                    title: const Text('Appearance'),
                    additionalInfo: CupertinoSlidingSegmentedControl<int>(
                      children: const {
                        0: Text('Light'),
                        1: Text('Dark'),
                      },
                      groupValue: _selectedTheme,
                      onValueChanged: (value) {
                        setState(() {
                          _selectedTheme = value!;
                        });
                      },
                    )),
                CupertinoListTile(
                  title: const Text('About'),
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
