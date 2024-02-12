import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:get/get.dart';

class TextTimeline extends StatelessWidget {
  const TextTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return _.isMediaImage
            ? _textTimeline(context, _.photoDuration * 50.0)
            : _.isVideoInitialized
                ? _textTimeline(context, _.videoDuration * 50.0)
                : SizedBox.shrink();
      },
    );
  }

  // Edit to show the different added texts
  _textTimeline(BuildContext context, double width) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.5),
            Container(
              width: width,
              height: 50.0,
              decoration: BoxDecoration(
                color: CustomColors.textTimeline.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: CustomColors.textTimeline.withOpacity(0.2),
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: [
                    Icon(
                      _.hasAudio ? Icons.text_fields : Icons.add,
                      color: CustomColors.textTimeline,
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        'Add text!',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.textTimeline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.5),
          ],
        );
      },
    );
  }
}
