import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class EditTextDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textEditController = TextEditingController(text: EditorController.to.selectedTextContent);

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
                  Text(translations.editTextDialogTitle.tr, style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 24.0),
                  TextField(
                    controller: textEditController,
                    onChanged: (value) => _.updateSelectedTextContent(value),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: translations.editTextDialogLabel.tr,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      border: OutlineInputBorder(),
                    ),
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
