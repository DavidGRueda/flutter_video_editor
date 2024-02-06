/// Used to store the transformations for the media.
class MediaTransformations {
  Duration trimStart = Duration.zero;
  Duration trimEnd = Duration.zero;
  String audioUrl = '';
  String audioName = '';

  MediaTransformations();

  MediaTransformations.fromJson(Map<String, dynamic> json)
      : trimStart = Duration(milliseconds: json['trimStart'] ?? 0),
        trimEnd = Duration(milliseconds: json['trimEnd'] ?? 0),
        audioUrl = json['audioUrl'] ?? '',
        audioName = json['audioName'] ?? '';

  Map<String, dynamic> toJson() => {
        'trimStart': trimStart.inMilliseconds,
        'trimEnd': trimEnd.inMilliseconds,
        'audioUrl': audioUrl,
        'audioName': audioName,
      };

  @override
  String toString() {
    return 'Trim start: $trimStart, Trim end: $trimEnd, Audio url: $audioUrl';
  }
}
