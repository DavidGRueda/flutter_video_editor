import 'package:flutter/material.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:image_picker/image_picker.dart';

class Project {
  String id;
  String name;
  XFile media;
  MediaTransformations transformations;

  Project({
    this.name = 'Untitled Project',
    required this.media,
  })  : id = UniqueKey().toString(),
        transformations = MediaTransformations();

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        media = XFile(json['media']),
        transformations = MediaTransformations.fromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'media': media.path,
        'transformations': transformations.toJson(),
      };
}
