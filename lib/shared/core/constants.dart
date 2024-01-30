abstract class Constants {
  static const String fallbackImage =
      'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg';

  static const String uploadMediaRootPath = 'media';
  static const String projectsRootPath = 'projects';
  static const String databaseUrl = 'https://flutter-video-editor-default-rtdb.europe-west1.firebasedatabase.app';
}

// ignore: constant_identifier_names
enum SelectedOptions { BASE, TRIM, AUDIO, TEXT, CROP }
