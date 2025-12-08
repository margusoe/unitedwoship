import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unitedwoship/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    final textTheme = CupertinoTheme.of(context).textTheme;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo512.png',
                  height: 120,
                  width: 120,
                  color: isDarkMode
                      ? AppTheme.darkTextColor
                      : AppTheme.lightPrimaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  _packageInfo.appName,
                  style: textTheme.navTitleTextStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  'Version: ${_packageInfo.version}',
                  style: textTheme.textStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Contact: unitedwoship@gmail.com',
                  style: textTheme.textStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                // Potentially add more information like privacy policy link, terms of service, etc.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
