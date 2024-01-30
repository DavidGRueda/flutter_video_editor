import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/edit_option.dart';
import 'package:flutter_video_editor/shared/core/CustomIcons_icons.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/widgets/edit_action_button.dart';
import 'package:get/get.dart';

class EditorActions extends StatelessWidget {
  // Base video options that will be displayed in the editor.
  final List<EditOption> baseVideoOptions = [
    EditOption(
      title: 'Trim',
      icon: Icons.cut_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.TRIM;
      },
    ),
    EditOption(title: 'Audio', icon: Icons.music_note_outlined, onPressed: () {}),
    EditOption(title: 'Text', icon: Icons.text_fields_outlined, onPressed: () {}),
    EditOption(title: 'Crop', icon: Icons.crop, onPressed: () {}),
  ];

  final List<EditOption> trimOptions = [
    EditOption(title: 'Set trim\nstart', icon: CustomIcons.trimEnd, onPressed: () {}),
    EditOption(title: 'Set trim\nend', icon: CustomIcons.trimStart, onPressed: () {}),
    EditOption(title: 'Jump\nback', icon: Icons.replay, onPressed: () {}),
    EditOption(title: 'Jump\nfoward', icon: CustomIcons.forward, onPressed: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 16.0),
        child: GetBuilder<EditorController>(
          builder: (_) {
            var options = baseVideoOptions;

            switch (_.selectedOptions) {
              case SelectedOptions.BASE:
                options = baseVideoOptions;
              case SelectedOptions.TRIM:
                options = trimOptions;
              default:
                options = baseVideoOptions;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _.selectedOptions != SelectedOptions.BASE
                    ? InkWell(
                        onTap: () => EditorController.to.selectedOptions = SelectedOptions.BASE,
                        child: SizedBox(
                          width: 40.0,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 10.0),
                      ...options.map(
                        (option) =>
                            EditActionButton(onPressed: option.onPressed, icon: option.icon, text: option.title),
                      ),
                      SizedBox(width: 10.0)
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
