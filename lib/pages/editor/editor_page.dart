import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/pages/editor/widgets/editor_actions.dart';
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
              EditorActions()
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                child: _.isVideoInitialized ? VideoPlayer(_.videoController!) : SizedBox(),
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
                      _.videoPositionString,
                      style:
                          Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '/${_.videoDurationString}',
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
                  height: 30.0,
                  width: 30.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
                    },
                    icon: _.isVideoPlaying ? Icon(Icons.pause_sharp) : Icon(Icons.play_arrow),
                    splashRadius: 16.0,
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
              height: 85.0,
            ),
          ),
          Column(
            children: [
              // Video Timeline
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _.scrollController,
                child: Column(
                  children: [
                    Row(
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
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Transform.translate(
                                      offset: Offset(-5.0, 0.0),
                                      child: Text(
                                        '$index',
                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                              overflow: TextOverflow.visible,
                                              fontWeight: FontWeight.bold,
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
                    SizedBox(height: 12.0),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                        CustomPaint(
                          painter: TrimPainter(_.trimStart, _.trimEnd),
                          child: Container(
                              width: _.videoDuration * 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      _.project.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
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

class TrimPainter extends CustomPainter {
  final int msTrimStart;
  final int msTrimEnd;

  TrimPainter(this.msTrimStart, this.msTrimEnd);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the x-coordinates for trim start and trim end lines
    double startX = (msTrimStart / 1000) * 50.0;
    double endX = (msTrimEnd / 1000) * 50.0;

    endX = endX.clamp(0.0, size.width);
    // Draw trim start line only if it's not at the beginning
    if (startX > 0) {
      drawRoundedRectangleWithOpacity(canvas, 0.0, startX, Colors.black.withOpacity(0.15), size, true);
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX, size.height),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0,
      );

      drawTriangle(
        canvas,
        Offset(startX, 1),
        Colors.red,
        false, // pointing down
      );
    }

    // Draw trim end line only if it's not at the end
    if (endX < size.width) {
      canvas.drawLine(
        Offset(endX, 0),
        Offset(endX, size.height),
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2.0,
      );

      drawTriangle(
        canvas,
        Offset(endX, 1),
        Colors.blue,
        false,
      );
      drawRoundedRectangleWithOpacity(canvas, endX, size.width, Colors.black.withOpacity(0.15), size, false);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is TrimPainter) {
      return msTrimStart != oldDelegate.msTrimStart || msTrimEnd != oldDelegate.msTrimEnd;
    }
    return true;
  }

  void drawTriangle(Canvas canvas, Offset position, Color color, bool pointingDown) {
    final path = Path();
    const triangleHeight = 6.0;

    if (pointingDown) {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx - triangleHeight, position.dy + triangleHeight);
      path.lineTo(position.dx + triangleHeight, position.dy + triangleHeight);
    } else {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx - triangleHeight, position.dy - triangleHeight);
      path.lineTo(position.dx + triangleHeight, position.dy - triangleHeight);
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void drawRoundedRectangleWithOpacity(Canvas canvas, double start, double end, Color color, Size size, bool isStart) {
    final radius = Radius.circular(10.0);
    final rect = RRect.fromRectAndCorners(
      Rect.fromPoints(Offset(start, 0), Offset(end, size.height)),
      topLeft: isStart ? radius : Radius.zero,
      topRight: isStart ? Radius.zero : radius,
      bottomLeft: isStart ? radius : Radius.zero,
      bottomRight: isStart ? Radius.zero : radius,
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}
