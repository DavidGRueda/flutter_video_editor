import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  ScrollController scrollController = ScrollController();

  Duration? _position = Duration(seconds: 0);

  get videoController => _videoController;
  bool get isVideoInitialized => _videoController != null && _videoController!.value.isInitialized;
  bool get isVideoPlaying => _videoController != null && _videoController!.value.isPlaying;
  double get videoAspectRatio => _videoController!.value.aspectRatio;
  double get videoPosition => (_position!.inMilliseconds.toDouble() / 1000);
  double get videoDuration => isVideoInitialized ? _videoController!.value.duration.inSeconds.toDouble() : 0.0;

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

      _videoController!.addListener(() {
        final previousPos = _position;

        // Update the video position every frame.
        _position = _videoController!.value.position;

        // If the video has reached the end, pause it and reset the position.
        if (_position!.inSeconds.toDouble() == videoDuration) {
          _videoController!.pause();
          _videoController!.seekTo(Duration(seconds: 0));
          scrollController.jumpTo(0);
          return;
        }

        // Make timeline scroll smoothly.
        int posDif = _position!.inMilliseconds - previousPos!.inMilliseconds;

        // Animate the video timeline scroll position to match the video position.
        if (!(scrollController.position.userScrollDirection != ScrollDirection.idle) && posDif > 0) {
          double scrollPosition = ((_position!.inMilliseconds) * 0.001 * 50.0).ceilToDouble();
          scrollController.animateTo(scrollPosition, duration: Duration(milliseconds: posDif), curve: Curves.linear);
        }

        update();
      });
      update();
    });

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection != ScrollDirection.idle) {
        pauseVideo();
        updateVideoPosition(scrollController.position.pixels / 50.0);
      }
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

  updateVideoPosition(double position) {
    // Convert the position to milliseconds and seek to that position.
    _videoController!.seekTo(Duration(milliseconds: (position * 1000).toInt()));
    update();
  }
}
