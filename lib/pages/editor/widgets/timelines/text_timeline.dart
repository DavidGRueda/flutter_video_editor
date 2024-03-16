import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/add_text_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/select_text_dialog.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class TextTimeline extends StatelessWidget {
  const TextTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return _.isVideoInitialized ? _textTimeline(context, _.videoDurationMs / 1000 * 50.0) : SizedBox.shrink();
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
            InkWell(
              onTap: () {
                if (_.selectedOptions != SelectedOptions.TEXT) {
                  _.selectedOptions = SelectedOptions.TEXT;
                }
                if (!_.hasText) {
                  Get.dialog(AddTextDialog());
                }
              },
              child: Container(
                width: width,
                height: 50.0,
                decoration: BoxDecoration(
                  color: CustomColors.textTimeline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: CustomColors.textTimeline.withOpacity(0.4),
                    width: 2.0,
                  ),
                ),
                child: !_.hasText
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: CustomColors.textTimeline,
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                translations.textTimelineAddText.tr,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.textTimeline),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          ...List.generate(_.nTexts, (i) {
                            TextTransformation text = _.texts[i];
                            bool isTextSelected = _.selectedTextId == text.id;

                            return Row(
                              children: [
                                Container(width: (text.msStartTime / 1000 * 50.0)),
                                InkWell(
                                  onTap: () {
                                    if (_.selectedOptions != SelectedOptions.TEXT) {
                                      _.selectedOptions = SelectedOptions.TEXT;
                                    }
                                    _.selectedTextId = text.id;
                                  },
                                  onLongPress: () {
                                    Get.dialog(SelectTextDialog());
                                  },
                                  child: Container(
                                    width: ((text.msDuration / 1000) * 50.0) - 4.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: isTextSelected ? Colors.white : CustomColors.textTimelineLight,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: CustomColors.textTimeline.withOpacity(isTextSelected ? 1.0 : 0.75),
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            text.text,
                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                  color: CustomColors.textTimeline,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
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
