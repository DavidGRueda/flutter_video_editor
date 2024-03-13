import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/repositories/project_repository.dart';
import 'package:flutter_video_editor/services/transform_service.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

/// GetX Controller dedicated to the state management of the new project screen.
/// Will use then user [Project] model to store the data.
class NewProjectController extends GetxController {
  NewProjectController();

  static NewProjectController get to => Get.find();

  final _projectRepository = ProjectRepository();
  final _transformService = TransformService();

  // Used to display the media if it's a video
  VideoPlayerController? _videoController;
  Duration? _position = const Duration(seconds: 0);

  String projectName = 'Untitled project';
  XFile? _media;
  int _photoDuration = 4;

  XFile? get media => _media;
  bool get isMediaEmpty => _media == null;
  bool get isMediaImage => _media != null && isImage(_media!.path);

  int get photoDuration => _photoDuration;
  set photoDuration(int newPhotoDuration) {
    _photoDuration = newPhotoDuration;
    update();
  }

  // Getters for the video player functionality
  bool get isVideoInitialized => _videoController != null && _videoController!.value.isInitialized;
  bool get isVideoPlaying => _videoController != null && _videoController!.value.isPlaying;
  get videoAspectRatio => _videoController!.value.aspectRatio;
  get videoPosition => [_position!.inSeconds ~/ 60, _position!.inSeconds % 60];
  get videoDuration =>
      '${convertTwo(_videoController!.value.duration.inSeconds ~/ 60)}:${convertTwo(_videoController!.value.duration.inSeconds % 60)}';

  get videoController => _videoController;

  @override
  void onClose() {
    super.onClose();
    // Dispose of the video player controller when the editor is closed.
    _videoController?.dispose();
    _videoController = null;
  }

  void clearMedia() {
    _media = null;
    _videoController?.dispose();
    update();
  }

  void pickImageFromCamera() async {
    final XFile? pickedMedia = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedMedia != null) {
      _media = pickedMedia;
    }
    update();
  }

  void pickVideoFromCamera() async {
    final XFile? pickedMedia = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedMedia != null) {
      _media = pickedMedia;
    }
    _initializeVideoController();
    update();
  }

  void pickMediaFromGallery() async {
    final XFile? pickedMedia = await ImagePicker().pickMedia();
    if (pickedMedia != null) {
      _media = pickedMedia;
      if (!isImage(_media!.path)) {
        _initializeVideoController();
      }
    }
    update();
  }

  void _initializeVideoController() {
    // Dispose of the previous video controller if it exists
    if (_videoController != null) {
      _videoController!.dispose();
      _position = Duration(seconds: 0);
    }

    _videoController = VideoPlayerController.file(File(media!.path));
    _videoController!.initialize().then((_) {
      _videoController!.setLooping(true);

      // Update the video position every second
      _videoController!.addListener(() {
        _position = _videoController?.value.position;
        update();
      });
      update();
    });
  }

  void pauseVideo() {
    _videoController!.pause();
    update();
  }

  void playVideo() {
    _videoController!.play();
    update();
  }

  void jump5Foward() {
    _videoController!.seekTo(_videoController!.value.position + const Duration(seconds: 5));
    update();
  }

  void jump5Backward() {
    _videoController!.seekTo(_videoController!.value.position - const Duration(seconds: 5));
    update();
  }

  /// Creates a new [Project] with the current controller data.
  ///
  /// If the user is logged in, it will add the project to the database.
  void createProject() async {
    ProjectsController.to.isCreatingProject = true;

    // Get userId to add the project to the database
    String? userId = GoogleSignInController.to.isUserSignedIn ? GoogleSignInController.to.user!.uid : null;
    String mediaUrl = _media!.path;
    String mediaName = isImage(mediaUrl) ? '${_media!.name.split('.').first}.mp4' : _media!.name;
    String mediaThumbnailUrl = '';

    // If the media is an image, it should be transformed into a video and then uploaded to the database.
    if (isImage(mediaUrl)) {
      try {
        mediaUrl = await _transformService.imageToVideo(mediaUrl, _photoDuration);
      } catch (e) {
        print('Error transforming image to video: $e');
        ProjectsController.to.isCreatingProject = false;
        showSnackbar(
          Theme.of(Get.context!).colorScheme.error,
          translations.errorAddingProjectTitle.tr,
          translations.errorAddingProjectMessage.tr,
          Icons.error_outline,
        );
        return;
      }
    }

    // Generate a media thumbnail. It should be uploaded to the database only if the user is logged in.
    mediaThumbnailUrl = await _transformService.generateThumbnail(mediaUrl, mediaName);
    if (mediaThumbnailUrl == '') {
      print('Error generating thumbnail');
      ProjectsController.to.isCreatingProject = false;
      showSnackbar(
        Theme.of(Get.context!).colorScheme.error,
        translations.errorAddingProjectTitle.tr,
        translations.errorAddingProjectMessage.tr,
        Icons.error_outline,
      );
      return;
    }

    // Media file & thumbnail should be uploaded to the database only if the user is logged in.
    if (userId != null) {
      mediaUrl = await _projectRepository.uploadMediaFile(mediaUrl, mediaName, userId);
      mediaThumbnailUrl =
          await _projectRepository.uploadMediaThumbnail(mediaThumbnailUrl, mediaName.split('.').first, userId);
      print('Media uploaded to $mediaUrl');
    }

    ProjectsController.to.addProject(Project(
      userId: userId,
      name: projectName,
      mediaUrl: mediaUrl,
      thumbnailUrl: mediaThumbnailUrl,
      photoDuration: _photoDuration,
    ));
  }
}
