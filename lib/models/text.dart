import 'package:uuid/uuid.dart';

class TextTransformation {
  String id;
  String text;
  int msDuration;
  int msStartTime;
  String color;
  double fontSize;

  TextTransformation({
    required this.text,
    required this.msDuration,
    required this.msStartTime,
    this.color = '0xFFFFFF',
    this.fontSize = 16.0,
  }) : id = Uuid().v4().replaceAll('-', '');

  TextTransformation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        msDuration = (json['msDuration'] ?? 3000).toInt(),
        msStartTime = (json['msStartTime'] ?? 0).toInt(),
        color = json['color'],
        fontSize = json['fontSize'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'msDuration': msDuration,
        'msStartTime': msStartTime,
        'color': color,
        'fontSize': fontSize,
      };
}
