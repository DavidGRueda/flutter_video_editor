import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:get/get.dart';

class AudioStartSheet extends StatelessWidget {
  const AudioStartSheet({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(builder: (_) {
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              //            Audio Start Container
              // -----------------------------------------------
              Text(
                'Audio start',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: RoundedProgressBarPainter(
                      msMaxAudioDuration: _.afterExportVideoDuration.toDouble(),
                      currentPosition: _.relativeAudioPosition.toDouble(),
                    ),
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _.audioScrollController,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                              _.sAudioDuration,
                              (index) => SizedBox(
                                  width: 12.0,
                                  child: index % 4 == 0
                                      ? Transform.translate(
                                          offset: Offset(-2.0, 0.0),
                                          child: Text(
                                            '${index ~/ 60 > 0 ? '${index ~/ 60}:' : ''}${index % 60}',
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.visible,
                                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                                                ),
                                          ))
                                      : SizedBox.shrink()),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                            )
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                              _.sAudioDuration,
                              (index) => Container(
                                width: 12.0,
                                height: index % 2 == 0 ? 40.0 : 25.0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // -----------------------------------------------
              //            Audio Controls
              // -----------------------------------------------
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border:
                          Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.35), width: 2.0),
                    ),
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        !_.isAudioPlaying ? _.playAudio() : _.pauseAudio();
                      },
                      icon: _.isAudioPlaying ? Icon(Icons.pause_sharp) : Icon(Icons.play_arrow),
                      splashRadius: 16.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
