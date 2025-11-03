import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:xml/xml.dart';

class SongScreen extends StatefulWidget {
  final int songId;
  const SongScreen({super.key, required this.songId});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  double _scrollSpeed = 50;
  late String _currentKey;
  late Song song;
  final webApi = getIt<WebApi>();

  @override
  void initState() {
    super.initState();
    song = webApi.getSong(widget.songId);
    _currentKey = song.songkey;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(song.title),
            Text(
                song.info
                    .firstWhere((element) => element.type == 'A',
                        orElse: () =>
                            SongInfo(value: 'Unknown Artist', type: 'A'))
                    .value,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: const Icon(CupertinoIcons.ellipsis),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), child: Text(song.songxml)),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  bool _isChordLine(XmlElement line) {
    if (line.children.isEmpty) return false;
    bool hasChords = false;
    for (var node in line.children) {
      if (node is XmlElement && node.name.local == 's') {
        hasChords = true;
      } else if (node is XmlText && node.text.trim().isNotEmpty) {
        return false;
      }
    }
    return hasChords;
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      color: AppTheme.darkSurfaceColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Scroll Speed'),
              Expanded(
                child: CupertinoSlider(
                  value: _scrollSpeed,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    setState(() {
                      _scrollSpeed = value;
                    });
                  },
                ),
              ),
              Text('${_scrollSpeed.toInt()}%'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {},
                      child: const Icon(CupertinoIcons.minus),
                    ),
                    Expanded(
                      child: Text(
                        'Key: $_currentKey',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {},
                      child: const Icon(CupertinoIcons.add),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.darkPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    CupertinoIcons.play_arrow_solid,
                    color: AppTheme.darkOnPrimaryColor,
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {},
                      child: const Text('A-'),
                    ),
                    CupertinoButton(
                      onPressed: () {},
                      child: const Text('A+'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
