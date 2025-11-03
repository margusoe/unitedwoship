import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:xml/xml.dart';

class SongScreen extends StatefulWidget {
  final Song song;
  const SongScreen({super.key, required this.song});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  double _scrollSpeed = 50;
  late String _currentKey;

  @override
  void initState() {
    super.initState();
    _currentKey = widget.song.songkey;
  }

  @override
  Widget build(BuildContext context) {
    final document = XmlDocument.parse(widget.song.songxml);
    final lines = document.findAllElements('l');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.song.title),
            Text(
                widget.song.info
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var line in lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            for (var node in line.children)
                              if (node is XmlElement && node.name.local == 's')
                                TextSpan(
                                  text: node.text,
                                  style: TextStyle(
                                    color: AppTheme.primaryColor(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else if (node is XmlText)
                                TextSpan(
                                  text: node.text,
                                  style: AppTheme.bodyStyle(context),
                                ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildBottomControls(),
        ],
      ),
    );
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
                    Text('Key: $_currentKey'),
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
