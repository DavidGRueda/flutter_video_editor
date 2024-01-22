import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';

String convertTwo(int value) => value < 10 ? '0$value' : '$value';

Future<Uint8List?> getLocalVideoThumbnail(String mediaPath) async {
  return VideoThumbnail.thumbnailData(
    video: mediaPath,
    imageFormat: ImageFormat.JPEG,
    quality: 50,
  );
}

Future<String?> getNetworkVideoThumbnail(String mediaUrl) async {
  return VideoThumbnail.thumbnailFile(
    video: mediaUrl,
    imageFormat: ImageFormat.JPEG,
    quality: 50,
  );
}
