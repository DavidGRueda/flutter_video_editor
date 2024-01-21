/// Used to store the transformations for the media.
class MediaTransformations {
  Duration _duration = Duration.zero; // example. To be replaced with real data.

  MediaTransformations();

  MediaTransformations.fromJson(Map<String, dynamic> json) : _duration = Duration(milliseconds: json['duration'] ?? 0);

  Map<String, dynamic> toJson() => {
        'duration': _duration.inMilliseconds,
      };
}
