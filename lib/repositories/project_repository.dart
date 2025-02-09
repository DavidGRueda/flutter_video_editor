import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';

class ProjectRepository {
  final Reference rootStorage = FirebaseStorage.instance.ref().child(Constants.uploadMediaRootPath);
  final DatabaseReference rootDatabase = FirebaseDatabase.instance.ref(Constants.projectsRootPath);
  static DefaultCacheManager cacheManager = DefaultCacheManager();

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
        // Set base project data
        Map<String, dynamic> data = value.cast<String, dynamic>();
        Project p = Project.fromJson(data);

        // Set the transformations
        p.transformations = MediaTransformations.fromJson(data['transformations'].cast<String, dynamic>());

        // Set the text transformations
        p.transformations.texts = data['transformations']['texts'] != null
            ? (data['transformations']['texts'] as List)
                .map((text) => TextTransformation.fromJson(text.cast<String, dynamic>()))
                .toList()
            : [];

        projects.add(p);
      });
      return projects..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }
    return [];
  }

  // Uploads the media file to the cloud storage and returns the download URL
  Future<String> uploadMediaFile(String mediaUrl, String mediaName, String userId) async {
    Reference userStorage = rootStorage.child(userId);
    Reference mediaStorage = userStorage.child('$userId-${DateTime.now().millisecondsSinceEpoch}--$mediaName');

    // Upload the file to the cloud storage
    await mediaStorage.putFile(File(mediaUrl));
    return await mediaStorage.getDownloadURL();
  }

  // Uploads the media thumbnail to the cloud storage and returns the download URL
  Future<String> uploadMediaThumbnail(String mediaUrl, String mediaName, String userId) async {
    Reference userStorage = rootStorage.child('$userId/thumbnails');
    Reference mediaStorage =
        userStorage.child('$userId-${DateTime.now().millisecondsSinceEpoch}--$mediaName-thumbnail.jpg');

    // Upload the file to the cloud storage
    await mediaStorage.putFile(File(mediaUrl));
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

  void updateProject(Project project, String userId, ProjectEdits projectEdits) {
    // Update the project in the database
    rootDatabase.child('$userId/${project.projectId}').update(projectEdits.toJson());
  }

  void saveProjectTransformations(Project project, String userId) {
    Map<String, dynamic> transformations = {
      'transformations': project.transformations.toJson(),
      'lastUpdated': DateTime.now().toString(),
    };
    rootDatabase.child('$userId/${project.projectId}').update(transformations);
  }

  void deleteProject(Project project, String userId) {
    // Delete the project media from the cloud storage
    FirebaseStorage.instance.refFromURL(project.mediaUrl).delete();

    // Delete the project thumbnail if it exists from the cloud storage
    if (project.thumbnailUrl != '') {
      FirebaseStorage.instance.refFromURL(project.thumbnailUrl).delete();
    }

    // Delete the project from the database
    rootDatabase.child('$userId/${project.projectId}').remove();
  }

  // Get the project media file from the cache so it reduces bandwidth usage.
  Future<File> getProjectMedia(String mediaUrl) async {
    return await cacheManager.getSingleFile(mediaUrl);
  }
}
