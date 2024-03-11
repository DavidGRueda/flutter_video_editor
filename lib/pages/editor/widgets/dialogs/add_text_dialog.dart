import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';
import 'package:get/get.dart';

class AddTextDialog extends StatelessWidget {
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
                  Text('Add new text', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 24.0),
                  Text(
                    'The text will be added in the current video position',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    onChanged: (value) => _.textToAdd = value,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: 'Text to add',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _.textToAdd = '';
                        },
                        icon: Icon(Icons.cancel_outlined),
                        splashRadius: 20.0,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Text duration', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColoredIconButton(
                        backgroundColor: Theme.of(context).primaryColorLight.withOpacity(Get.isDarkMode ? 1 : 0.2),
                        icon: Icons.remove,
                        onPressed: () {
                          _.textDuration > 1 ? _.textDuration -= 1 : _.textDuration = 1;
                        },
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColorLight, width: 2.0),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('${_.textDuration}s', style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ColoredIconButton(
                        backgroundColor: Theme.of(context).primaryColorLight.withOpacity(Get.isDarkMode ? 1 : 0.2),
                        icon: Icons.add,
                        onPressed: () {
                          _.textDuration += 1;
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          elevation: 0.0,
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        ),
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: _.textToAdd != ''
                            ? () {
                                _.addProjectText();
                                Get.back();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          disabledBackgroundColor: Theme.of(context).disabledColor,
                          disabledForegroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: _.textToAdd == ''
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).primaryColorLight,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Text('Save',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
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
