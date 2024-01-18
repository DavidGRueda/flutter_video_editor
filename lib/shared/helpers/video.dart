import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

String convertTwo(int value) => value < 10 ? '0$value' : '$value';

Future<Uint8List?> getVideoThumbnail(XFile media) async {
  return VideoThumbnail.thumbnailData(
    video: media.path,
    imageFormat: ImageFormat.JPEG,
    quality: 50,
  );
}
