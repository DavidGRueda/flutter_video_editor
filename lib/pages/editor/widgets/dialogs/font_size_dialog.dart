import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:get/get.dart';

class FontSizeDialog extends StatelessWidget {
  const FontSizeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set font size', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _.selectedTextContent,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: _.selectedTextFontSize, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text('Font size', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.0),
                  Slider(
                    value: _.selectedTextFontSize,
                    min: 8.0,
                    max: 64.0,
                    divisions: 56,
                    label: _.selectedTextFontSize.round().toString(),
                    onChanged: (double value) => _.updateTextFontSize(value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
