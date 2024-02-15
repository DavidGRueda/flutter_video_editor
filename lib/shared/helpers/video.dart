import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

String convertTwo(int value) => value < 10 ? '0$value' : '$value';
String convertThree(int value) => value < 10
    ? '00$value'
    : value < 100
        ? '0$value'
        : '$value';

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

List<MainAxisAlignment> getTextAlignmentFromPosition(TextPosition p) {
  // Get horizontal and vertical FFMPEG positions
  List<String> pos = p.toString().split('.')[1].split('');
  String vPos = pos[0];
  String hPos = pos[1];

  // Get horizontal alignment
  MainAxisAlignment rowAlignment = hPos == 'L'
      ? MainAxisAlignment.start
      : hPos == 'C'
          ? MainAxisAlignment.center
          : MainAxisAlignment.end;

  // Get vertical alignment
  MainAxisAlignment columnAlignment = vPos == 'T'
      ? MainAxisAlignment.start
      : vPos == 'C'
          ? MainAxisAlignment.center
          : MainAxisAlignment.end;

  return [rowAlignment, columnAlignment];
}
