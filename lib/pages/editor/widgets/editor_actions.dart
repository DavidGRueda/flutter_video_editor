import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/edit_option.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
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
    EditOption(
      title: 'Audio',
      icon: Icons.music_note_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.AUDIO;
      },
    ),
    EditOption(title: 'Text', icon: Icons.text_fields_outlined, onPressed: () {}),
    EditOption(
        title: 'Crop',
        icon: Icons.crop,
        onPressed: () {
          Get.toNamed(Routes.EXPORT);
        }),
  ];

  final List<EditOption> trimOptions = [
    EditOption(
      title: 'Set trim\nstart',
      icon: CustomIcons.trimEnd,
      onPressed: () {
        EditorController.to.setTrimStart();
      },
    ),
    EditOption(
      title: 'Set trim\nend',
      icon: CustomIcons.trimStart,
      onPressed: () {
        EditorController.to.setTrimEnd();
      },
    ),
    EditOption(
      title: 'Jump\nback',
      icon: Icons.replay,
      onPressed: () {
        EditorController.to.jumpBack50ms();
      },
    ),
    EditOption(
      title: 'Jump\nfoward',
      icon: CustomIcons.forward,
      onPressed: () {
        EditorController.to.jumpForward50ms();
      },
    ),
  ];

  final List<EditOption> audioOptions = [
    EditOption(
      title: EditorController.to.hasAudio ? 'Change\naudio' : 'Add\naudio',
      icon: Icons.add,
      onPressed: () {
        EditorController.to.pickAudio();
      },
    ),
    EditOption(
      title: 'Remove\naudio',
      icon: Icons.remove_circle_outline,
      onPressed: () {
        EditorController.to.removeAudio();
      },
    ),
    EditOption(title: 'Track\nvolume', icon: Icons.volume_up_outlined, onPressed: () {}),
    EditOption(title: 'Audio\nstart', icon: Icons.start_outlined, onPressed: () {}),
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
              case SelectedOptions.AUDIO:
                options = audioOptions;
              default:
                options = baseVideoOptions;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _.selectedOptions != SelectedOptions.BASE
                    ? InkWell(
                        onTap: () => goBack(_),
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
                        (option) => EditActionButton(
                          onPressed: option.onPressed,
                          icon: option.icon,
                          text: option.title,
                        ),
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

  goBack(EditorController _) {
    if (_.selectedOptions == SelectedOptions.TRIM) {
      // Jump to the start of the video / trim start.
      _.jumpToStart();
    }
    _.selectedOptions = SelectedOptions.BASE;
  }
}
