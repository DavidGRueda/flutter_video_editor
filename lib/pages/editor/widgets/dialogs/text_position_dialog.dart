import 'package:flutter/material.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';

import '../../../../controllers/editor_controller.dart';

class TextPositionDialog extends StatelessWidget {
  const TextPositionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(builder: (_) {
      return Dialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set text position', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Stack(
                      children: [
                        ...TextPosition.values.map((tp) {
                          final [rowAlignment, columnAlignment] = getTextAlignmentFromPosition(tp);

                          return Column(
                            mainAxisAlignment: columnAlignment,
                            children: [
                              Row(
                                mainAxisAlignment: rowAlignment,
                                children: [
                                  GestureDetector(
                                    onTap: () => _.updateTextPosition(tp),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.65 / 3 - 2,
                                      height: MediaQuery.of(context).size.width * 0.65 / 3 - 2,
                                      decoration: BoxDecoration(
                                        color: _.selectedTextPosition == tp
                                            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: _.selectedTextPosition == tp
                                              ? Colors.transparent
                                              : Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: _.selectedTextPosition == tp
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context).colorScheme.primary,
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        })
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
