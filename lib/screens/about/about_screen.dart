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
        title: const Text('Бидний Тухай'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Холбоо барих',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SelectableText.rich(
              TextSpan(children: [
                TextSpan(
                  text:
                      'Асуух асуулт эсвэл санал хүслээрээ бидэнтэй холбоо барихыг хүсвэл, энэ имэйл хаягаар холбоо барина уу: ',
                ),
                TextSpan(
                  text: 'otgonchuluubayarsaikhan@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Text(
              'Лицензи',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Creative Commons CC0 1.0 Universal (CC0 1.0)-ын нээлттэй эх сурвалжын өмч болно.',
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
                valueListenable: versionNotifier,
                builder: (context, version, child) {
                  return Text(
                    'Хувилбар: $version',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
