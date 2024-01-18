import 'dart:io';

import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// GetX Controller dedicated to the state management of the new project screen.
/// Will use then user [Project] model to store the data.
class NewProjectController extends GetxController {
  NewProjectController();

  static NewProjectController get to => Get.find();

  // Used to display the media if it's a video
  VideoPlayerController? _videoController;

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

  get videoController => _videoController;

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
    }

    _videoController = VideoPlayerController.file(File(media!.path));
    _videoController!.initialize().then((_) {
      _videoController!.setLooping(true);
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
}
