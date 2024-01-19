import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/repositories/project_repository.dart';
import 'package:get/get.dart';

/// GetX Controller dedicated to the state management of projects.
/// Will use the [Project] model to store the data, using GetBuilder to update the UI (not reactive).
class ProjectsController extends GetxController {
  ProjectsController();

  static ProjectsController get to => Get.find();

  final _projects = <Project>[];
  bool _projectsLoaded = false;
  final _projectService = ProjectRepository();

  // Getters and setters
  List<Project> get projects => _projects;
  set projects(newProjects) {
    _projects.clear();
    _projects.addAll(newProjects);
    update();
  }

  bool get projectsLoaded => _projectsLoaded;
  set projectsLoaded(bool value) {
    _projectsLoaded = value;
    update();
  }

  // Adds a new project to the list
  void addProject(Project project) {
    // TODO: Add project to the database when it's created
    _projects.add(project);
    update();
  }

  @override
  void onInit() {
    // Load the projects from the database. Mocked for now.
    super.onInit();
    _projectService.getProjects().then((projects) {
      projectsLoaded = true;
      this.projects = projects;
    });
  }
}
