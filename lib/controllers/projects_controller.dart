import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/repositories/project_repository.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:get/get.dart';

/// GetX Controller dedicated to the state management of projects.
/// Will use the [Project] model to store the data, using GetBuilder to update the UI (not reactive).
class ProjectsController extends GetxController {
  ProjectsController();

  static ProjectsController get to => Get.find();

  final _projects = <Project>[];
  bool _projectsLoaded = false;
  final _projectRepository = ProjectRepository();

  // Getters and setters
  List<Project> get projects => _projects;
  set projects(List<Project> newProjects) {
    _projects.clear();
    _projects.addAll(newProjects);
    update();
  }

  bool get projectsLoaded => _projectsLoaded;
  set projectsLoaded(bool value) {
    _projectsLoaded = value;
    update();
  }

  // Adds a new project locally and, if the user is signed in, to the cloud.
  void addProject(Project project) {
    _projects.insert(0, project);

    // Upload the project and show snackbar if the project is being uploaded to the cloud (user is signed in).
    if (GoogleSignInController.to.isUserSignedIn) {
      _projectRepository.addProject(project);
      showSnackbar(
        CustomColors.success,
        'Project created!',
        'Your project was created successfully',
        Icons.check_circle_outlined,
      );
    }
    update();
  }

  void deleteProject(String projectId) {
    final Project projectToDelete = _projects.firstWhere((project) => project.projectId == projectId);
    // Remove the project from the local list
    _projects.remove(projectToDelete);

    // Delete the project from the cloud if the user is signed in.
    if (GoogleSignInController.to.isUserSignedIn) {
      _projectRepository.deleteProject(projectToDelete, GoogleSignInController.to.userUid);
    }

    update();
  }

  /// Gets the projects from the cloud and updates the local projects list.
  /// This method is called every time the user signs in or out (or initializes the app).
  getProjects(String userUid) {
    _projectsLoaded = false;
    _projectRepository.getProjects(userUid).then((projects) {
      projectsLoaded = true;
      this.projects = projects;
    });
  }
}
