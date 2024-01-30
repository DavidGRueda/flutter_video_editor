import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/widgets/edit_action_button.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditorPage extends StatelessWidget {
  EditorPage({super.key});

  // ignore: unused_field
  final _editorController = Get.put(EditorController(project: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _editorAppBar(context),
      body: GetBuilder<EditorController>(
        builder: (_) {
          return Column(
            children: [
              _videoPlayer(context),
              !_.isMediaImage ? _videoControls(context) : SizedBox(),
              SizedBox(height: 16.0),
              !_.isMediaImage ? _videoTimeline(context) : SizedBox(),
              Expanded(
                child: SizedBox(),
              ),
              _editActions(context)
            ],
          );
        },
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

  _videoControls(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: GetBuilder<EditorController>(
          builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Video position text
                Row(
                  children: [
                    Text(
                      '${_.videoPositionString}/',
                      style:
                          Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _.videoDurationString,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.35), width: 2.0),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
                    },
                    icon: _.isVideoPlaying ? Icon(Icons.pause_sharp) : Icon(Icons.play_arrow),
                    splashRadius: 24.0,
                  ),
                ),
                // Other controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.undo_outlined),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.redo_outlined),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.fullscreen_outlined),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ));
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

  _videoTimeline(BuildContext context) {
    return GetBuilder<EditorController>(builder: (_) {
      return Stack(
        children: [
          CustomPaint(
            painter: LinePainter(_.videoPosition),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          Column(
            children: [
              // Video Timeline
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _.scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                      ...List.generate(
                        _.videoDuration.toInt(),
                        (index) => Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2), width: 1.0),
                              bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2), width: 1.0),
                            ),
                          ),
                          width: 50.0, // Adjust the width of each timeline item
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Transform.translate(
                                    offset: Offset(-5.0, 0.0),
                                    child: Text(
                                      '$index',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            overflow: TextOverflow.visible,
                                          ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: 6.0,
                                    width: 2.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(2.0),
                                    )),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // Should refactor this at some point
  _editActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 10.0),
            EditActionButton(onPressed: () {}, icon: Icons.cut_outlined, text: 'Trim'),
            EditActionButton(onPressed: () {}, icon: Icons.music_note_outlined, text: 'Audio'),
            EditActionButton(onPressed: () {}, icon: Icons.text_fields_outlined, text: 'Text'),
            EditActionButton(onPressed: () {}, icon: Icons.crop, text: 'Crop'),
            SizedBox(width: 10.0)
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double videoPosition;

  LinePainter(this.videoPosition);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    // Paint labelPaint = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.fill;

    // Draw a vertical line at the center
    canvas.drawLine(Offset(size.width / 2, -5), Offset(size.width / 2, size.height), linePaint);

    // Draw a label background with border radius
    // Rect labelRect = Rect.fromLTWH(
    //   size.width / 2 - 20, // Adjust the position of the label
    //   -20,
    //   40,
    //   20,
    // );
    // RRect roundedRect = RRect.fromRectAndRadius(labelRect, Radius.circular(10.0));
    // canvas.drawRRect(roundedRect, labelPaint);

    // Draw a label text at the top of the vertical line
    // TextSpan span = TextSpan(
    //   style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(color: Colors.white),
    //   text: videoPosition.toStringAsFixed(2),
    // );
    // TextPainter tp = TextPainter(
    //   text: span,
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // );
    // tp.layout();
    // tp.paint(canvas, Offset(size.width / 2 - tp.width / 2, -20));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
