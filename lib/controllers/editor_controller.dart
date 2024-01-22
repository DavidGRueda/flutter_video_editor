import 'dart:io';

import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditorController extends GetxController {
  EditorController({required this.project});

  // Project that will be worked on.
  final Project project;

  static EditorController get to => Get.find();

  bool get isMediaImage => isImage(project.mediaUrl);
  bool get isMediaNetworkPath => isNetworkPath(project.mediaUrl);

  // Video controller for the video player (if needed).
  VideoPlayerController? _videoController;
  get videoController => _videoController;
  bool get isVideoInitialized => _videoController != null && _videoController!.value.isInitialized;
  bool get isVideoPlaying => _videoController != null && _videoController!.value.isPlaying;
  double get videoAspectRatio => _videoController!.value.aspectRatio;

  @override
  void onInit() {
    super.onInit();
    // Initialize the video player controller if the project has a video.
    _initializeVideoController();
  }

  @override
  void onClose() {
    super.onClose();
    // Dispose of the video player controller when the editor is closed.
    _videoController?.dispose();
    _videoController = null;
  }

  void _initializeVideoController() {
    // Only initialize the video player controller if the project media is a video.
    if (!isVideo(project.mediaUrl)) return;

    isNetworkPath(project.mediaUrl)
        ? _videoController = VideoPlayerController.networkUrl(Uri.parse(project.mediaUrl))
        : _videoController = VideoPlayerController.file(File(project.mediaUrl));

    _videoController!.initialize().then((_) {
      _videoController!.setLooping(true);
      update();
    });
  }

  pauseVideo() {
    _videoController!.pause();
    update();
  }

  playVideo() {
    _videoController!.play();
    update();
  }
}
