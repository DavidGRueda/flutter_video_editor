import 'package:flutter_video_editor/models/project.dart';
import 'package:image_picker/image_picker.dart';

class ProjectsService {
  // Mocked projects. To be deleted.
  final mockedProjects = [
    Project(
      name: 'Project 1',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      name: 'Project 2',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      name: 'Project 3',
      media: XFile('assets/placeholder.png'),
    ),
    Project(
      name: 'Project 4',
      media: XFile('assets/placeholder.png'),
    ),
  ];

  Future<List<Project>> getProjects() async {
    // TODO: Get projects from the database. Now it's mocked.
    await Future.delayed(Duration(seconds: 3));
    return mockedProjects;
  }
}
