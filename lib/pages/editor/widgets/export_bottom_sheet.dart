import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:get/get.dart';

class ExportBottomSheet extends StatelessWidget {
  const ExportBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      painter: DragHandlePainter(),
                      child: SizedBox(),
                    )
                  ],
                ),
                SizedBox(height: 32.0),
                // -----------------------------------------------
                //                  Export Options
                // -----------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Resolution', style: Theme.of(context).textTheme.titleMedium),
                    Text('Improves video quality', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                Slider(
                  value: _.resolution.toDouble(),
                  min: 0.0,
                  max: 3.0,
                  divisions: 3,
                  label: Constants.videoResolutionLabels[_.resolution],
                  onChanged: (double value) {
                    _.resolution = value.toInt();
                  },
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FPS', style: Theme.of(context).textTheme.titleMedium),
                    Text('Frames per second', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                Slider(
                  value: _.fps.toDouble(),
                  min: 0.0,
                  max: 3.0,
                  divisions: 3,
                  label: Constants.videoFpsLabels[_.fps],
                  onChanged: (double value) {
                    _.fps = value.toInt();
                  },
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bitrate', style: Theme.of(context).textTheme.titleMedium),
                    Text('Video compression', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                Slider(
                  value: _.bitrate.toDouble(),
                  min: 0.0,
                  max: 4.0,
                  divisions: 4,
                  label: Constants.videoBitrateLabels[_.bitrate],
                  onChanged: (double value) {
                    _.bitrate = value.toInt();
                  },
                ),

                // -----------------------------------------------
                //                  Export Button
                // -----------------------------------------------
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.file_upload_outlined, size: 26.0),
                      label: Text(
                        'Export',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
