import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:get/get.dart';

class VideoTimeline extends StatelessWidget {
  const VideoTimeline({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return _.isVideoInitialized
            ? Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                  CustomPaint(
                      painter: TrimPainter(_.trimStart, _.trimEnd),
                      child: _videoTimeline(context, _.videoDuration * 50.0)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                ],
              )
            : SizedBox.shrink();
      },
    );
  }

  _videoTimeline(BuildContext context, double width) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return Container(
          width: width,
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
                Icon(
                  Icons.video_camera_back,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 4.0),
                Text(
                  _.project.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
