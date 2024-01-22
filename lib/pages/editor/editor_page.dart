import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditorPage extends StatelessWidget {
  EditorPage({super.key});

  final _editorController = Get.put(EditorController(project: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _editorAppBar(context),
      body: Column(
        children: [
          _videoPlayer(context),
          Expanded(
            child: SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _editorAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      titleSpacing: 0,
      shape: RoundedRectangleBorder(),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Get back to project page row
            InkWell(
              onTap: () => Get.back(),
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              child: Row(
                children: [
                  Icon(Icons.keyboard_backspace, color: Theme.of(context).colorScheme.onBackground, size: 26.0),
                  SizedBox(width: 4.0),
                  Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.onBackground, size: 26.0),
                ],
              ),
            ),
            // Project save and export row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.save_outlined, size: 26.0),
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {},
                  splashRadius: 20.0,
                ),
                IconButton(
                  icon: Icon(Icons.file_upload_outlined, size: 26.0),
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {},
                  splashRadius: 20.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _videoPlayer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Colors.black,
          ),
          child: GetBuilder<EditorController>(
            builder: (_) {
              return _.isMediaImage ? _imageContainer() : _videoContainer();
            },
          )),
    );
  }

  _videoContainer() {
    return GetBuilder<EditorController>(
      builder: (_) {
        return InkWell(
          onTap: () {
            _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
          },
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _.isVideoInitialized ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: AspectRatio(
                aspectRatio: _.videoAspectRatio,
                child: VideoPlayer(_.videoController!),
              ),
            ),
          ),
        );
      },
    );
  }

  _imageContainer() {
    return GetBuilder<EditorController>(
      builder: (_) {
        // return
        return Align(
          alignment: Alignment.center,
          child: _.isMediaNetworkPath ? Image.network(_.project.mediaUrl) : Image.file(File(_.project.mediaUrl)),
        );
      },
    );
  }
}
