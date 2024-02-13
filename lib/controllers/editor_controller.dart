import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/ffmpeg.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
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

  int get photoDuration => project.photoDuration;

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
  int get exportVideoDuration => isVideoInitialized ? _videoController!.value.duration.inMilliseconds : 0;
  int get afterExportVideoDuration =>
      project.transformations.trimEnd.inMilliseconds - project.transformations.trimStart.inMilliseconds;

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
  int get trimEnd => project.transformations.trimEnd.inMilliseconds;

  // Audio options
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioInitialized = false;
  ScrollController audioScrollController = ScrollController();

  Duration _audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;
  int get sAudioDuration => _audioDuration.inSeconds;
  int get msAudioEnd => audioStart.inMilliseconds + afterExportVideoDuration;

  // Used for the progress bar in the audio start bottom sheet
  int get relativeAudioPosition => audioPosition.inMilliseconds - audioStart.inMilliseconds;
  bool get canSetAudioStart => hasAudio && isAudioInitialized && sAudioDuration > (afterExportVideoDuration / 1000);

  PlayerState? _audioPlayerState;
  PlayerState get audioPlayerState => _audioPlayerState ?? PlayerState.stopped;
  set audioPlayerState(PlayerState audioPlayerState) {
    _audioPlayerState = audioPlayerState;
    update();
  }

  bool get isAudioPlaying => _audioPlayerState == PlayerState.playing;

  Duration get audioStart => project.transformations.audioStart;

  bool get hasAudio => project.transformations.audioUrl.isNotEmpty;
  bool get isAudioInitialized => _isAudioInitialized;
  set isAudioInitialized(bool isAudioInitialized) {
    _isAudioInitialized = isAudioInitialized;
    update();
  }

  double get masterVolume => project.transformations.masterVolume;
  set masterVolume(double masterVolume) {
    project.transformations.masterVolume = masterVolume;
    videoController.setVolume(masterVolume);
    update();
  }

  double get audioVolume => project.transformations.audioVolume;
  set audioVolume(double audioVolume) {
    project.transformations.audioVolume = audioVolume;
    _audioPlayer.setVolume(audioVolume);
    update();
  }

  String get audioName => project.transformations.audioName;

  // ------------------ TEXT VARIABLES ------------------------

  String _textToAdd = '';
  String get textToAdd => _textToAdd;
  set textToAdd(String value) {
    _textToAdd = value;
    update();
  }

  int _textDuration = 5;
  int get textDuration => _textDuration;
  set textDuration(int value) {
    _textDuration = value;
    update();
  }

  get hasText => project.transformations.texts.isNotEmpty;
  get texts => project.transformations.texts.length > 1
      ? project.transformations.texts.sort(
          (a, b) => a.msStartTime - b.msStartTime,
        )
      : project.transformations.texts;
  get nTexts => project.transformations.texts.length;

  // ------------------ END TEXT VARIABLES ------------------------

  @override
  void onInit() async {
    super.onInit();

    // Initialize the video player controller if the project has a video.
    await _initializeVideoController();

    // Initialize the audio player if the project has audio.
    if (hasAudio) {
      _initializeAudio();
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Dispose of the video player controller when the editor is closed.
    _videoController?.dispose();
    _audioPlayer.dispose();
    _videoController = null;
  }

  Future<void> _initializeVideoController() async {
    // Only initialize the video player controller if the project media is a video.
    if (!isVideo(project.mediaUrl)) return;

    // Get the cached project media file (only if its network path).
    if (isNetworkPath(project.mediaUrl)) {
      projectMediaFile = await ProjectsController.to.getProjectMedia(project.mediaUrl);
      _videoController = VideoPlayerController.file(
        projectMediaFile!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      _videoController = VideoPlayerController.file(
        File(project.mediaUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }

    _videoController!.initialize().then((_) {
      _videoController!.setLooping(false);
      _videoController!.setVolume(masterVolume);

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

  // Initialize the audio player with the project audio.
  _initializeAudio() {
    _audioPlayer.setSource(DeviceFileSource(project.transformations.audioUrl));
    _audioPlayer.setVolume(audioVolume);
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _audioDuration = d;
      update();
    });
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _audioPlayerState = state;
      update();
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      audioPosition = p;
      if (p.inMilliseconds > msAudioEnd) {
        pauseAudio();
      }
      update();
    });
    audioScrollController.addListener(() {
      if (audioScrollController.position.userScrollDirection != ScrollDirection.idle) {
        int newPosInMilliseconds = ((audioScrollController.position.pixels / 12.0) * 1000).toInt();
        project.transformations.audioStart = Duration(milliseconds: newPosInMilliseconds);
        _audioPlayer.seek(Duration(milliseconds: newPosInMilliseconds));
      }
      update();
    });
    isAudioInitialized = true;
  }

  playAudio() {
    if (_isAudioInitialized) {
      _audioPlayer.resume();
    }
    update();
  }

  pauseAudio() {
    if (_isAudioInitialized) {
      _audioPlayer.pause();
      _audioPlayer.seek(audioStart);
    }
    update();
  }

  scrollToAudioStart() {
    audioScrollController.jumpTo(audioStart.inMilliseconds * 0.001 * 12.0);
  }

  onAudioStartSheetClosed() {
    if (isAudioPlaying) {
      pauseAudio();
      jumpToStart();
    }
  }

  pauseVideo() {
    if (isAudioInitialized) {
      _audioPlayer.pause();
    }
    _videoController!.pause();
    update();
  }

  playVideo() {
    if (isAudioInitialized) {
      _audioPlayer.resume();
    }
    _videoController!.play();
    update();
  }

  updateVideoPosition(double position) {
    // Convert the position to milliseconds and seek to that position.
    _videoController!.seekTo(Duration(milliseconds: (position * 1000).toInt()));
    if (isAudioInitialized) {
      // Go to the relative position in the audio.
      _audioPlayer.seek(Duration(milliseconds: (position * 1000).toInt() + audioStart.inMilliseconds - trimStart));
    }
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
    if (isAudioInitialized) {
      _audioPlayer.seek(audioStart);
      _audioPlayer.pause();
    }
    update();
  }

  pickAudio() async {
    // If the video is playing, pause it.
    if (isVideoPlaying) {
      pauseVideo();
    }

    FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    ).then((result) {
      if (result != null) {
        project.transformations.audioUrl = result.files.single.path!;
        project.transformations.audioName = result.files.single.name;
        project.transformations.audioStart = Duration.zero;
        _initializeAudio();
        update();
      }
    });
  }

  removeAudio() {
    if (hasAudio) {
      project.transformations.audioUrl = '';
      project.transformations.audioName = '';
      project.transformations.audioStart = Duration.zero;
      _audioPlayer.release();
      isAudioInitialized = false;
      update();
    } else {
      showSnackbar(
        Theme.of(Get.context!).colorScheme.error,
        "Denied operation",
        "No audio to remove",
        Icons.error_outline,
      );
    }
  }

  addProjectText() {
    TextTransformation t = TextTransformation(
      text: textToAdd,
      msDuration: textDuration * 1000,
      msStartTime: !isMediaImage ? _position!.inMilliseconds : 0,
    );
    project.transformations.texts.add(t);

    // Reset the textToAdd and textDuration variables.
    textToAdd = '';
    textDuration = 5;
  }

  exportVideo() async {
    if (isVideoPlaying) {
      pauseVideo();
    }

    // Generate the FFMPEG command and navigate to the export page.
    String dateTime = DateFormat('yyyyMMdd_HH:mm:ss').format(DateTime.now());
    String outputPath = await generateOutputPath('${project.name}_$dateTime');

    String command = generateFFMPEGCommand(
      projectMediaFile!.path,
      outputPath,
      exportVideoDuration,
      project.transformations,
    );

    // Log the command to be executed and close the bottom sheet
    print('Will execute : ffmpeg $command');
    Get.back();

    Get.toNamed(
      Routes.EXPORT,
      arguments: {'command': command, 'outputPath': outputPath, 'videoDuration': afterExportVideoDuration},
    );
  }
}
