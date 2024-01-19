import 'package:flutter/material.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:intl/intl.dart';

class Project {
  String projectId;
  String? userId;
  String name;
  String lastUpdated;
  int photoDuration;
  String mediaUrl;
  MediaTransformations transformations;

  Project({
    this.name = 'Untitled Project',
    required this.mediaUrl,
    required this.userId,
    this.photoDuration = 3,
  })  : projectId = UniqueKey().toString(),
        lastUpdated = DateFormat('dd.MM.yyyy').format(DateTime.now()),
        transformations = MediaTransformations();

  Project.fromJson(Map<String, dynamic> json)
      : projectId = json['id'],
        name = json['name'],
        lastUpdated = json['lastUpdated'],
        mediaUrl = json['mediaUrl'],
        photoDuration = json['photoDuration'],
        transformations = MediaTransformations.fromJson(json);

  Map<String, dynamic> toJson() => {
        'id': projectId,
        'name': name,
        'lastUpdated': lastUpdated,
        'mediaUrl': mediaUrl,
        'photoDuration': photoDuration,
        'transformations': transformations.toJson(),
      };
}
