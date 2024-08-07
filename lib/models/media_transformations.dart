import 'package:flutter_video_editor/shared/core/constants.dart';

import 'text.dart';

/// Used to store the transformations for the media.
class MediaTransformations {
  Duration trimStart = Duration.zero;
  Duration trimEnd = Duration.zero;
  String audioUrl = '';
  String audioName = '';
  double masterVolume = 1.0;
  double audioVolume = 1.0;
  Duration audioStart = Duration.zero;
  List<TextTransformation> texts = [];

  CropAspectRatio cropAspectRatio = CropAspectRatio.FREE;
  double cropX = 0;
  double cropY = 0;
  double cropWidth = 0;
  double cropHeight = 0;

  MediaTransformations();

  MediaTransformations.fromJson(Map<String, dynamic> json)
      : trimStart = Duration(milliseconds: json['trimStart'] ?? 0),
        trimEnd = Duration(milliseconds: json['trimEnd'] ?? 0),
        audioUrl = json['audioUrl'] ?? '',
        audioName = json['audioName'] ?? '',
        masterVolume = (json['masterVolume'] ?? 1.0).toDouble(),
        audioVolume = (json['audioVolume'] ?? 1.0).toDouble(),
        audioStart = Duration(milliseconds: json['audioStart'] ?? 0),
        cropAspectRatio = json['cropAspectRatio'] != null
            ? CropAspectRatio.values.firstWhere((e) => e.toString() == json['cropAspectRatio'])
            : CropAspectRatio.FREE,
        cropX = (json['cropX'] ?? 0).toDouble(),
        cropY = (json['cropY'] ?? 0).toDouble(),
        cropWidth = (json['cropWidth'] ?? 0).toDouble(),
        cropHeight = (json['cropHeight'] ?? 0).toDouble();

  Map<String, dynamic> toJson() => {
        'trimStart': trimStart.inMilliseconds,
        'trimEnd': trimEnd.inMilliseconds,
        'audioUrl': audioUrl,
        'audioName': audioName,
        'masterVolume': masterVolume,
        'audioVolume': audioVolume,
        'audioStart': audioStart.inMilliseconds,
        'texts': texts.map((text) => text.toJson()).toList(),
        'cropAspectRatio': cropAspectRatio.toString(),
        'cropX': cropX,
        'cropY': cropY,
        'cropWidth': cropWidth,
        'cropHeight': cropHeight,
      };

  @override
  String toString() {
    return 'Trim start: $trimStart, Trim end: $trimEnd, Audio url: $audioUrl';
  }
}
