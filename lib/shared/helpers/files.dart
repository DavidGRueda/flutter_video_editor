import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

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

String getFileExtension(String path) {
  String finalPath = path;
  if (isNetworkPath(path)) {
    finalPath = path.split('?').first;
  }
  return lookupMimeType(finalPath)!.split('/').last;
}

Future<String> generateOutputPath(String filename) async {
  // Get the application documents directory and create the output path.
  final Directory directory = await getTemporaryDirectory();
  return '${directory.path}/$filename.mp4';
}

Future<String> generateThumbnailPath(String filename) async {
  // Get the application documents directory and create the output path.
  final Directory directory = await getTemporaryDirectory();
  return '${directory.path}/$filename.jpg';
}
