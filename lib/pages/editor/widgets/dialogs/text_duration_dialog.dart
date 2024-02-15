import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:get/get.dart';

class TextDurationDialog extends StatelessWidget {
  const TextDurationDialog({Key? key}) : super(key: key);

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
              Text('Set text duration', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 24.0),
              Slider(
                value: _.selectedTextDuration.toDouble(),
                min: 100.0,
                max: _.maxSelectedTextDuration.toDouble(),
                label: '${_.selectedTextDuration / 1000} s',
                onChanged: (value) => _.updateTextDuration(value.toInt()),
              )
            ],
          ),
        ),
      );
    });
  }
}
