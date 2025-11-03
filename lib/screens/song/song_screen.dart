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

class SongLyrics extends StatelessWidget {
  final String xmlContent;

  const SongLyrics({super.key, required this.xmlContent});

  @override
  Widget build(BuildContext context) {
    try {
      final fixedXml =
          '<root>${xmlContent.replaceAll('<br />', '<br/>').replaceAll('<br>', '<br/>')}</root>';
      final document = XmlDocument.parse(fixedXml);
      final root = document.rootElement;

      List<Widget> songWidgets = [];
      final sections = root.children
          .whereType<XmlElement>()
          .where((e) => e.name.local != 'br' && e.name.local != 'chord')
          .toList();

      if (sections.isNotEmpty) {
        // Has sections like <verse>, <chorus>
        for (var element in sections) {
          songWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Text(
                _formatSectionTitle(element.name.local),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );

          songWidgets.addAll(_parseNodes(element.nodes, context));
        }
      } else {
        // No sections, just a list of nodes
        songWidgets.addAll(_parseNodes(root.nodes, context));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: songWidgets,
      );
    } catch (e) {
      return Text(xmlContent);
    }
  }

  List<Widget> _parseNodes(Iterable<XmlNode> nodes, BuildContext context) {
    List<Widget> widgets = [];
    var currentLineNodes = <XmlNode>[];
    for (var node in nodes) {
      if (node is XmlElement && node.name.local == 'br') {
        if (currentLineNodes.isNotEmpty) {
          widgets.add(_buildLine(currentLineNodes, context));
        }
        currentLineNodes = [];
      } else {
        currentLineNodes.add(node);
      }
    }
    if (currentLineNodes.isNotEmpty) {
      widgets.add(_buildLine(currentLineNodes, context));
    }
    return widgets;
  }

  Widget _buildLine(List<XmlNode> nodes, BuildContext context) {
    var widgets = <Widget>[];
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node is XmlElement && node.name.local == 'chord') {
        String chord = node.text;
        String lyric = '';

        if (i + 1 < nodes.length && nodes[i + 1] is XmlText) {
          lyric = nodes[i + 1].text;
          i++;
        }

        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chord,
                style: TextStyle(
                  color: AppTheme.darkPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                lyric,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      } else if (node is XmlText) {
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                node.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widgets,
      ),
    );
  }

  String _formatSectionTitle(String title) {
    final regex = RegExp(r'([a-zA-Z]+)(\d*)');
    final match = regex.firstMatch(title);
    if (match != null) {
      String text = match.group(1)!;
      String number = match.group(2)!;
      text = text[0].toUpperCase() + text.substring(1);
      if (number.isNotEmpty) {
        return '[$text $number]';
      }
      return '[$text]';
    }
    return '[$title]';
  }
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
                padding: const EdgeInsets.all(16.0),
                child: SongLyrics(xmlContent: song.songxml)),
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
