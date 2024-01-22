import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProjectRepository {
  final Reference rootStorage = FirebaseStorage.instance.ref().child(Constants.uploadMediaRootPath);
  final DatabaseReference rootDatabase = FirebaseDatabase.instance.ref(Constants.projectsRootPath);

  Future<List<Project>> getProjects(String userId) async {
    print('Getting projects for user $userId');
    if (userId == '') return [];
    // Get user projects from the database.
    final snapshot = await rootDatabase.child(userId).get();
    if (snapshot.exists) {
      // Convert the projects to a list of Project objects.
      final projects = <Project>[];
      Map projectsMap = snapshot.value as Map;
      projectsMap.forEach((key, value) {
        projects.add(Project.fromJson(value.cast<String, dynamic>()));
      });
      return projects..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }
    return [];
  }

  // Uploads the media file to the cloud storage and returns the download URL
  Future<String> uploadMediaFile(XFile mediaFile, String userId) async {
    Reference userStorage = rootStorage.child(userId);
    Reference mediaStorage = userStorage.child('$userId-${DateTime.now().millisecondsSinceEpoch}--${mediaFile.name}');

    // Upload the file to the cloud storage
    await mediaStorage.putFile(File(mediaFile.path));
    return await mediaStorage.getDownloadURL();
  }

  void addProject(Project project) async {
    // Projects will be stored in the database using the structure projects/{userId}/{projectId}
    DatabaseReference newProject = rootDatabase.child('${project.userId!}/${project.projectId}');
    try {
      newProject.set(project.toJson());
    } catch (e) {
      print('There was an error uploading the project: $e');
    }
  }

  void deleteProject(Project project, String userId) {
    // Delete the project media from the cloud storage
    FirebaseStorage.instance.refFromURL(project.mediaUrl).delete();

    // Delete the project from the database
    rootDatabase.child('$userId/${project.projectId}').remove();
  }
}
