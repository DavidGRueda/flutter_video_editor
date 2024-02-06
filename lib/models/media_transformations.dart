/// Used to store the transformations for the media.
class MediaTransformations {
  Duration trimStart = Duration.zero;
  Duration trimEnd = Duration.zero;
  String audioUrl = '';
  String audioName = '';
  double masterVolume = 1.0;
  double audioVolume = 1.0;

  MediaTransformations();

  MediaTransformations.fromJson(Map<String, dynamic> json)
      : trimStart = Duration(milliseconds: json['trimStart'] ?? 0),
        trimEnd = Duration(milliseconds: json['trimEnd'] ?? 0),
        audioUrl = json['audioUrl'] ?? '',
        audioName = json['audioName'] ?? '',
        masterVolume = (json['masterVolume'] ?? 1.0).toDouble(),
        audioVolume = (json['audioVolume'] ?? 1.0).toDouble();

  Map<String, dynamic> toJson() => {
        'trimStart': trimStart.inMilliseconds,
        'trimEnd': trimEnd.inMilliseconds,
        'audioUrl': audioUrl,
        'audioName': audioName,
        'masterVolume': masterVolume,
        'audioVolume': audioVolume,
      };

  @override
  String toString() {
    return 'Trim start: $trimStart, Trim end: $trimEnd, Audio url: $audioUrl';
  }
}
