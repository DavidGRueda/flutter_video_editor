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
  String thumbnailUrl;
  MediaTransformations transformations;

  Project({
    this.name = 'Untitled Project',
    required this.mediaUrl,
    required this.thumbnailUrl,
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
        thumbnailUrl = json['thumbnailUrl'] ?? '',
        transformations = MediaTransformations.fromJson(json);

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'name': name,
        'lastUpdated': lastUpdated.toString(),
        'mediaUrl': mediaUrl,
        'thumbnailUrl': thumbnailUrl,
        'photoDuration': photoDuration,
        'transformations': transformations.toJson(),
      };

  @override
  String toString() {
    return 'Project: $name, Last updated: $lastUpdated - Media URL: $mediaUrl - Photo duration: $photoDuration - Transformations: ${transformations.toString()}';
  }
}

/// Used to store [Project] edits.
/// Fields should have the same name as the [Project] fields.
class ProjectEdits {
  final String name;

  ProjectEdits(this.name);

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
