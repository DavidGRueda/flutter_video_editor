/// Used to store the transformations for the media.
class MediaTransformations {
  Duration trimStart = Duration.zero;
  Duration trimEnd = Duration.zero;

  MediaTransformations();

  MediaTransformations.fromJson(Map<String, dynamic> json)
      : trimStart = Duration(milliseconds: json['duration'] ?? 0),
        trimEnd = Duration(milliseconds: json['trimEnd'] ?? 0);

  Map<String, dynamic> toJson() => {
        'trimStart': trimStart.inMilliseconds,
        'trimEnd': trimEnd.inMilliseconds,
      };
}
