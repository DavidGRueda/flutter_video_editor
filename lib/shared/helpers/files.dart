import 'package:mime/mime.dart';

bool isImage(String path) {
  String finalPath = path;
  if (isNetworkPath(path)) {
    finalPath = path.split('?').first;
  }
  final mimeType = lookupMimeType(finalPath);
  return mimeType!.startsWith('image/');
}

bool isVideo(String path) {
  String finalPath = path;
  if (isNetworkPath(path)) {
    finalPath = path.split('?').first;
  }
  final mimeType = lookupMimeType(finalPath);
  return mimeType!.startsWith('video/');
}

isNetworkPath(String path) {
  return path.startsWith('http');
}
