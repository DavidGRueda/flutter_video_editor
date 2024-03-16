// ignore_for_file: constant_identifier_names

abstract class Constants {
  static const String fallbackImage =
      'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg';

  static const String uploadMediaRootPath = 'media';
  static const String projectsRootPath = 'projects';
  static const String databaseUrl = 'https://flutter-video-editor-default-rtdb.europe-west1.firebasedatabase.app';
  static const String guideUrl =
      'https://sleet-valley-872.notion.site/Gu-a-de-LiteEdit-efb7780ee3dc439eb02a9f368972767f';

  static const List<String> videoResolutionLabels = ['480p', '720p', '1080p', '2K'];
  // If the video is horizontal, the width will be the first value, otherwise the height will be the first value.
  static const List<String> resolutionScaleValues = ['640', '1280', '1920', '2560'];

  static const List<String> videoBitrates = ['400k', '800k', '1.2M', '1.6M', '4M'];
  static const List<String> videoBitrateLabels = ['Low', 'Medium', 'High', 'HD', 'HD1080'];

  static const List<String> videoFps = ['15', '24', '30', '60'];
  static const List<String> videoFpsLabels = ['15fps', '24fps', '30fps', '60fps'];
}

enum SelectedOptions { BASE, TRIM, AUDIO, TEXT, CROP }

enum SocialMedia { FACEBOOK, WHATSAPP, INSTAGRAM, OTHER }

enum ColorPickerContext { BACKGROUND, TEXT }

// Position of the text in the video.
// TL = Top Left, TC = Top Center, TR = Top Right,
// ML = Middle Left,MC = Middle Center, MR = Middle Right,
// BL = Bottom Left, BC = Bottom Center, BR = Bottom Right
enum TextPosition { TL, TC, TR, ML, MC, MR, BL, BC, BR }

enum CropAspectRatio { FREE, SQUARE, RATIO_16_9, RATIO_9_16, RATIO_4_5 }
