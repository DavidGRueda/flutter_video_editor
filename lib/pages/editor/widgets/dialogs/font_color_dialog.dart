import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:get/get.dart';

import '../../../../controllers/editor_controller.dart';

class FontColorDialog extends StatelessWidget {
  final ColorPickerContext context;

  const FontColorDialog({required this.context});

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
              children: [
                ColorPicker(
                  color: Color(
                    int.parse(
                      this.context == ColorPickerContext.TEXT
                          ? _.selectedTextColor
                          : _.selectedTextBackgroundColor != ''
                              ? _.selectedTextBackgroundColor
                              : '0xFFFFFFFF',
                    ),
                  ),
                  onColorChanged: (Color color) => this.context == ColorPickerContext.TEXT
                      ? _.updateFontColor(color)
                      : _.updateBackgroundColor(color),
                  heading: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      this.context == ColorPickerContext.TEXT ? 'Select font color' : 'Select background color',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  wheelWidth: MediaQuery.of(context).size.width * 0.06,
                  wheelDiameter: MediaQuery.of(context).size.width * 0.65,
                  pickersEnabled: {
                    ColorPickerType.wheel: true,
                    ColorPickerType.accent: false,
                    ColorPickerType.primary: false
                  },
                ),
                this.context == ColorPickerContext.BACKGROUND
                    ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        ElevatedButton.icon(
                          onPressed: () => _.clearBackgroundColor(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _.selectedTextBackgroundColor == ''
                                ? Colors.grey.withOpacity(0.5)
                                : Theme.of(context).colorScheme.error,
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          ),
                          icon: Icon(Icons.delete_outline, color: Colors.white),
                          label: Text('Clear',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                        ),
                      ])
                    : SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}
