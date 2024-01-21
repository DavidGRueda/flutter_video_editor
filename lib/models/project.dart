import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Project {
  String projectId;
  String? userId;
  String name;
  DateTime lastUpdated;
  int photoDuration;
  String mediaUrl;
  MediaTransformations transformations;

  Project({
    this.name = 'Untitled Project',
    required this.mediaUrl,
    required this.userId,
    this.photoDuration = 3,
  })  : projectId = Uuid().v4().replaceAll('-', ''),
        lastUpdated = DateTime.now(),
        transformations = MediaTransformations();

  Project.fromJson(Map<String, dynamic> json)
      : projectId = json['projectId'],
        name = json['name'],
        lastUpdated = DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['lastUpdated'].split('.')[0]),
        mediaUrl = json['mediaUrl'],
        photoDuration = json['photoDuration'],
        transformations = MediaTransformations.fromJson(json);

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'name': name,
        'lastUpdated': lastUpdated.toString(),
        'mediaUrl': mediaUrl,
        'photoDuration': photoDuration,
        'transformations': transformations.toJson(),
      };
}
