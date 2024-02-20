import 'package:uuid/uuid.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';

class TextTransformation {
  String id;
  String text;
  int msDuration;
  int msStartTime;
  String color;
  String backgroundColor;
  TextPosition position;
  double fontSize;

  TextTransformation({
    required this.text,
    required this.msDuration,
    required this.msStartTime,
    this.color = '0xFFFFFFFF',
    this.fontSize = 16.0,
    this.backgroundColor = '',
    this.position = TextPosition.BC,
  }) : id = Uuid().v4().replaceAll('-', '');

  TextTransformation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        msDuration = (json['msDuration'] ?? 3000).toInt(),
        msStartTime = (json['msStartTime'] ?? 0).toInt(),
        color = json['color'],
        backgroundColor = json['backgroundColor'],
        fontSize = (json['fontSize'] ?? 16.0).toDouble(),
        position = json['position'] != null
            ? TextPosition.values.firstWhere((e) => e.toString() == json['position'])
            : TextPosition.BC;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'msDuration': msDuration,
        'msStartTime': msStartTime,
        'color': color,
        'backgroundColor': backgroundColor,
        'fontSize': fontSize,
        'position': position.toString()
      };

  bool shouldDisplay(int position) => position >= msStartTime && position <= msStartTime + msDuration;
}
