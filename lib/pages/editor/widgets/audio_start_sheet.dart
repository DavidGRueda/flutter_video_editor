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
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 64.0),
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
                    painter: RoundedProgressBarPainter(maxAudioDuration: 12, currentPosition: 4),
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _.audioScrollController,
                    child: Row(
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
