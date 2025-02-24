import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final versionNotifier = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    _getAppVersion().then((version) {
      versionNotifier.value = version;
    });
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Contact',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SelectableText.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'For any inquiries or feedback, please contact us at ',
                ),
                TextSpan(
                  text: 'otgonchuluubayarsaikhan@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Text(
              'License',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'This work is released under the Creative Commons CC0 1.0 Universal (CC0 1.0) Public Domain Dedication.',
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
                valueListenable: versionNotifier,
                builder: (context, version, child) {
                  return Text(
                    'Version: $version',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
