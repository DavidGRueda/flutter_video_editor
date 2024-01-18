import 'package:flutter/material.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Project {
  String id;
  String name;
  String lastUpdated;
  int photoDuration;
  XFile media;
  MediaTransformations transformations;

  Project({
    this.name = 'Untitled Project',
    required this.media,
    this.photoDuration = 3,
  })  : id = UniqueKey().toString(),
        lastUpdated = DateFormat('dd.MM.yyyy').format(DateTime.now()),
        transformations = MediaTransformations();

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lastUpdated = json['lastUpdated'],
        media = XFile(json['media']),
        photoDuration = json['photoDuration'],
        transformations = MediaTransformations.fromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastUpdated': lastUpdated,
        'media': media.path,
        'photoDuration': photoDuration,
        'transformations': transformations.toJson(),
      };
}
