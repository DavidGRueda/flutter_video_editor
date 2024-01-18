import 'package:mime/mime.dart';

bool isImage(String path) {
  final mimeType = lookupMimeType(path);
  return mimeType!.startsWith('image/');
}

bool isVideo(String path) {
  final mimeType = lookupMimeType(path);
  return mimeType!.startsWith('video/');
}
