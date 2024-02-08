import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:get/get.dart';

class TrackVolumeDialog extends StatelessWidget {
  const TrackVolumeDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return Dialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set track volume', style: Theme.of(Get.context!).textTheme.titleLarge),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: _.hasAudio ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                  children: [
                    // Sliders to control the audio volume.
                    Column(
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: _.masterVolume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 100,
                            label: '${(_.masterVolume * 100).round()}%',
                            onChanged: (double value) {
                              _.masterVolume = value;
                            },
                          ),
                        ),
                        Text(
                          'Master\nvolume',
                          textAlign: TextAlign.center,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    _.hasAudio
                        ? Column(
                            children: [
                              RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  thumbColor: CustomColors.audioTimeline,
                                  activeColor: CustomColors.audioTimeline,
                                  inactiveColor: CustomColors.audioTimeline.withOpacity(0.5),
                                  value: _.audioVolume,
                                  min: 0.0,
                                  max: 1.0,
                                  divisions: 100,
                                  label: '${(_.audioVolume * 100).round()}%',
                                  onChanged: (double value) {
                                    _.audioVolume = value;
                                  },
                                ),
                              ),
                              Text(
                                'Audio\nvolume',
                                textAlign: TextAlign.center,
                                style: Theme.of(Get.context!).textTheme.bodySmall,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
