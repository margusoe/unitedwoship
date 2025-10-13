import 'dart:convert';

class WebApi {
  Song getSong(int songId) {
    final jsonMap = json.decode(mockSong) as Map<String, dynamic>;
    return Song.fromJson(jsonMap['data']);
  }
}

class Song {
  final List<String> alternativeTitles;
  final int id;
  final String title;
  final String songkey;
  final String songxml;
  final List<SongInfo> info;

  Song({
    required this.alternativeTitles,
    required this.id,
    required this.title,
    required this.songkey,
    required this.songxml,
    required this.info,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      alternativeTitles: List<String>.from(json['alternative_titles']),
      id: json['id'],
      title: json['title'],
      songkey: json['songkey'],
      songxml: json['songxml'],
      info: (json['info'] as List).map((i) => SongInfo.fromJson(i)).toList(),
    );
  }
}

class SongInfo {
  final String value;
  final String type;

  SongInfo({required this.value, required this.type});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      value: json['value'],
      type: json['type'],
    );
  }
}

const mockSong = '''
{
    "success": true,
    "data": {
        "alternative_titles": [
            "Holy Forever"
        ],
        "id": 103875,
        "title": "Ариун Та мөнхөд",
        "songkey": "A",
        "songxml": "<verse><chord>A</chord>Мянга мянган үеүд <chord>D</chord>сөгдөн мөргөн <chord>A</chord>хүндлээд<br />\n<chord>F#m</chord>Магтан дуулна<chord>E</chord> Хурга Их Эзэ<chord>D</chord>нийг<br />\n<chord>A</chord>Бидний өмнөх хүмүүс, х<chord>D</chord>ожим итгэх <chord>A</chord>бүхэн<br />\n<chord>F#m</chord>Магтан дуулна<chord>E</chord> Хурга Их Эзэ<chord>D</chord>нийг</verse> <prechorus>Нэр <chord>D</chord>тань бүхнээс <chord>F#m</chord>өндөр, Нэр <chord>E</chord>тань бүхнээс агуу<br />\nНэр <chord>F#m</chord>тань бүхний дээр зал<chord>D</chord>рана<br />\nБүх <chord>D</chord>хаанчлал, эрх <chord>F#m</chord>мэдлүүд, хү<chord>E</chord>ч чадал, эд баялгаас ч<br />\nНэр <chord>F#m</chord>тань бүхний дээр за<chord>Bm</chord>лрана</prechorus> <chorus>Тэнгэр элч нар <chord>D</chord>магт,<chord>F#m</chord> Ари<chord>E</chord>ун<br />\nБүх бүтээлүүд <chord>A/C#</chord>магт, А<chord>F#m</chord>риун<br />\nТаныг өргөмж<chord>Bm</chord>лөнө, А<chord>E</chord>риун<br />\nАриун Та мөн<chord>A</chord>хөд</chorus> <verse><chord>A</chord>Уучлал олсон бүхэн, <chord>D</chord>аврал авсан <chord>A</chord>бүгд<br />\n<chord>F#m</chord>Магтан дуулна Ху<chord>E</chord>рга Их Эзэ<chord>D</chord>нийг<br />\n<chord>A</chord>Эрх чөлөөнд алхан,<chord>D</chord> Нэрийг тань т<chord>A</chord>ээгчид<br />\n<chord>F#m</chord>Магтан дуулна<chord>E</chord> Хурга Их Эзэ<chord>D</chord>нийг<br />\n<chord>F#m</chord>Магтаал хүндлэл өргөнө <chord>E</chord>үүрд А<chord>D</chord>мээн</verse> <chorus>Тэнгэр элч нар магт, Ариун<br />\nБүх бүтээлүүд магт, Ариун<br />\nТаныг өргөмжлөнө, Ариун<br />\nАриун Та мөнхөд<br />\nБидний дууг сонсооч, Ариун<br />\nХаадын Хааныг магт, Ариун<br />\nТа бол үүрд хэвээр, Ариун<br />\nАриун Та мөнхөд</chorus>",
        "info": [
            {
                "type": "wordsandmusic",
                "value": "Крис Томлин"
            }
        ]
    }
}
''';
