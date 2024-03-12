import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class SelectTextDialog extends StatelessWidget {
  const SelectTextDialog({Key? key}) : super(key: key);

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
                Text(translations.selectTextDialogTitle.tr, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 24.0),
                _textList(context),
              ],
            ),
          ),
        );
      },
    );
  }

  _textList(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _.nTexts,
          itemBuilder: (context, index) {
            TextTransformation text = _.texts[index];
            bool isTextSelected = text.id == _.selectedTextId;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    _.selectedTextId = text.id;

                    if (_.selectedOptions != SelectedOptions.TEXT) {
                      _.selectedOptions = SelectedOptions.TEXT;
                    }

                    Get.back();
                  },
                  child: Container(
                    width: (text.msDuration / 1000) * 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: isTextSelected ? Colors.white : CustomColors.textTimelineLight,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: CustomColors.textTimeline.withOpacity(isTextSelected ? 1.0 : 0.5),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text.text,
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: CustomColors.textTimeline,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                            ],
                          ),
                          isTextSelected
                              ? Icon(
                                  Icons.check,
                                  color: CustomColors.textTimeline,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
                index != _.nTexts - 1 ? SizedBox(height: 8.0) : SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
