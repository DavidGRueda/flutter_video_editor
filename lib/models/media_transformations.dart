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
  int cropX = 0;
  int cropY = 0;
  int cropWidth = 0;
  int cropHeight = 0;

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
        cropX = json['cropX'] ?? 0,
        cropY = json['cropY'] ?? 0,
        cropWidth = json['cropWidth'] ?? 0,
        cropHeight = json['cropHeight'] ?? 0;

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
