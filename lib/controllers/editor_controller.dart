import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditorController extends GetxController {
  EditorController({required this.project});

  // Project that will be worked on.
  final Project project;
  // Cached project media file.
  File? projectMediaFile;

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
  double get videoAspectRatio => isVideoInitialized ? _videoController!.value.aspectRatio : 1.0;
  double get videoPosition => (_position!.inMilliseconds.toDouble() / 1000);
  double get videoDuration => isVideoInitialized ? _videoController!.value.duration.inSeconds.toDouble() : 0.0;

  String get videoPositionString => '${convertTwo(_position!.inMinutes)}:${convertTwo(_position!.inSeconds)}';
  String get videoDurationString => isVideoInitialized
      ? '${convertTwo(_videoController!.value.duration.inMinutes)}:${convertTwo(_videoController!.value.duration.inSeconds)}'
      : '00:00';

  // Variables to control the export process.
  int _bitrate = 2;
  int get bitrate => _bitrate;
  set bitrate(int bitrate) {
    _bitrate = bitrate;
    update();
  }

  int _resolution = 2;
  int get resolution => _resolution;
  set resolution(int resolution) {
    _resolution = resolution;
    update();
  }

  int _fps = 2;
  int get fps => _fps;
  set fps(int fps) {
    _fps = fps;
    update();
  }

  // Set editor options
  SelectedOptions _selectedOptions = SelectedOptions.BASE;
  SelectedOptions get selectedOptions => _selectedOptions;
  set selectedOptions(SelectedOptions selectedOptions) {
    _selectedOptions = selectedOptions;
    update();
  }

  // Trim options
  int get trimStart => project.transformations.trimStart.inMilliseconds;
  // TODO: REFACTOR WITH ACTUAL CODE
  int get trimEnd => project.transformations.trimEnd.inMilliseconds != 0
      ? project.transformations.trimEnd.inMilliseconds
      : isVideoInitialized
          ? _videoController!.value.duration.inMilliseconds
          : 0;

  @override
  void onInit() async {
    super.onInit();
    // Initialize the video player controller if the project has a video.
    await _initializeVideoController();
  }

  @override
  void onClose() {
    super.onClose();
    // Dispose of the video player controller when the editor is closed.
    _videoController?.dispose();
    _videoController = null;
  }

  Future<void> _initializeVideoController() async {
    // Only initialize the video player controller if the project media is a video.
    if (!isVideo(project.mediaUrl)) return;

    // Get the cached project media file (only if its network path).
    if (isNetworkPath(project.mediaUrl)) {
      projectMediaFile = await ProjectsController.to.getProjectMedia(project.mediaUrl);
      _videoController = VideoPlayerController.file(projectMediaFile!);
    } else {
      _videoController = VideoPlayerController.file(File(project.mediaUrl));
    }

    _videoController!.initialize().then((_) {
      _videoController!.setLooping(false);
      // If the trim end is 0, set it to the video duration.
      if (project.transformations.trimEnd == Duration.zero) {
        project.transformations.trimEnd = _videoController!.value.duration;
      }

      // Jump to the start if there is a trim start.
      jumpToStart();

      _videoController!.addListener(() {
        final previousPos = _position;

        // Update the video position every frame.
        _position = _videoController!.value.position;

        // If the position is less than the trim start, jump to the start (if not in trim mode).
        if (_position!.inMilliseconds < trimStart && selectedOptions != SelectedOptions.TRIM) {
          jumpToStart();
          return;
        }

        // If the video has reached the end (or trimEnd), pause it and reset the position.
        if (_position!.inMilliseconds >= trimEnd && selectedOptions != SelectedOptions.TRIM) {
          jumpToStart();
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

  setTrimStart() {
    if (_position!.inMilliseconds < trimEnd) {
      project.transformations.trimStart = _position!;
    } else {
      showSnackbar(
        Theme.of(Get.context!).colorScheme.error,
        "Denied operation",
        "Cannot set the trim start after the trim end",
        Icons.error_outline,
      );
    }
    update();
  }

  setTrimEnd() {
    if (_position!.inMilliseconds > trimStart) {
      project.transformations.trimEnd = _position!;
    } else {
      showSnackbar(
        Theme.of(Get.context!).colorScheme.error,
        "Denied operation",
        "Cannot set the trim end before the trim start",
        Icons.error_outline,
      );
    }
    update();
  }

  jumpBack50ms() {
    _videoController!.seekTo(Duration(milliseconds: _position!.inMilliseconds - 50));
    scrollController.jumpTo(scrollController.position.pixels - 2.5);
    update();
  }

  jumpForward50ms() {
    _videoController!.seekTo(Duration(milliseconds: _position!.inMilliseconds + 50));
    scrollController.jumpTo(scrollController.position.pixels + 2.5);
    update();
  }

  jumpToStart() {
    _videoController!.pause();
    _videoController!.seekTo(Duration(milliseconds: trimStart));
    scrollController.jumpTo(trimStart * 0.001 * 50.0);
    update();
  }

  exportVideo() {
    // Generate the FFMPEG command and navigate to the export page.
  }
}
