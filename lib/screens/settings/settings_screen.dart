import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/app_state_manager.dart';
import 'package:magtaalhundetgel/infrastructure/service_locator.dart';
import 'package:magtaalhundetgel/infrastructure/user_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 17;
  @override
  void initState() {
    super.initState();
    _fontSize = getIt<UserSettings>().getFontSize();
  }

  final appStateManager = getIt<AppStateManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Font Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _fontSize,
              min: 14,
              max: 64,
              divisions: 25,
              label: '${(_fontSize)}',
              onChanged: (value) {
                _fontSize = value;
                setState(() {});
                appStateManager.setFontSize(_fontSize);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: appStateManager.darkModeNotifier,
                    builder: (context, isDarkMode, child) {
                      return Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          appStateManager.toggleDarkMode();
                        },
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
