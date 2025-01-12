import 'package:flutter/material.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How Great is Our God'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '                G',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('The splendor of the King'),
            Text(
              '                     Em',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Clothed in majesty'),
            Text(
              '                  C',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Let all the earth rejoice'),
            Text(
              '              D',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('All the earth rejoice'),
            SizedBox(height: 20),
            Text(
              '           G',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('He wraps Himself in light'),
            Text(
              '                    Em',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('And darkness tries to hide'),
            Text(
              '                 C',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('And trembles at His voice'),
            Text(
              '                 D',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Trembles at His voice'),
            SizedBox(height: 20),
            Text(
              'Chorus:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '      G',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('How great is our God'),
            Text(
              '                 C',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Sing with me'),
            Text(
              '                 Em          D',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('How great is our God'),
            Text(
              '                G',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('And all will see'),
            Text(
              '                 C    Em    D',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('How great, how great is our God'),
          ],
        ),
      ),
    );
  }
}
