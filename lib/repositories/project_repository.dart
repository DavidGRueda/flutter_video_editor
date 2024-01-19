import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProjectRepository {
  // Mocked projects. To be deleted.
  final mockedProjects = [
    Project(
      userId: null,
      name: 'Project 1',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      userId: null,
      name: 'Project 2',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      userId: null,
      name: 'Project 3',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      userId: null,
      name: 'Project 4',
      media: XFile('assets/placeholder.png'),
    ),
  ];

  Future<List<Project>> getProjects() async {
    // TODO: Get projects from the database. Now it's mocked.
    await Future.delayed(Duration(seconds: 3));
    return [];
  }

  void saveProject(Project project) {}

  // Uploads the media file to the cloud storage and returns the download URL
  Future<String> uploadMediaFile(XFile mediaFile, String userId) async {
    Reference rootStorage = FirebaseStorage.instance.ref().child(Constants.uploadMediaRootPath);
    Reference userStorage = rootStorage.child(userId);
    Reference mediaStorage = userStorage.child('$userId-${mediaFile.name}--${DateTime.now().millisecondsSinceEpoch}');

    // Upload the file to the cloud storage
    await mediaStorage.putFile(File(mediaFile.path));
    return await mediaStorage.getDownloadURL();
  }
}
