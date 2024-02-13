import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/edit_option.dart';
import 'package:flutter_video_editor/pages/editor/widgets/add_text_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/audio_start_sheet.dart';
import 'package:flutter_video_editor/pages/editor/widgets/track_volume_dialog.dart';
import 'package:flutter_video_editor/shared/core/CustomIcons_icons.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
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
    EditOption(
      title: 'Text',
      icon: Icons.text_fields_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.TEXT;
      },
    ),
    EditOption(title: 'Crop', icon: Icons.crop, onPressed: () {}),
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
    EditOption(
        title: 'Track\nvolume',
        icon: Icons.volume_up_outlined,
        onPressed: () {
          Get.dialog(TrackVolumeDialog());
        }),
    EditOption(
        title: 'Set audio\nstart',
        icon: Icons.start_outlined,
        onPressed: () {
          // Only display the bottom sheet if the video has audio and the audio duration is bigger than the
          // final video duration.
          if (EditorController.to.hasAudio && EditorController.to.canSetAudioStart) {
            Get.bottomSheet(AudioStartSheet()).then((value) {
              EditorController.to.onAudioStartSheetClosed();
            });
            Future.delayed(Duration(milliseconds: 300), () {
              EditorController.to.scrollToAudioStart();
            });
          } else {
            showSnackbar(
              CustomColors.error,
              'Cannot set audio start',
              EditorController.to.hasAudio
                  ? 'The audio duration is smaller than the video duration'
                  : 'No audio has been added to the video',
              Icons.error_outline,
            );
          }
        }),
  ];

  final List<EditOption> textOptions = [
    EditOption(
      title: 'Add\ntext',
      icon: Icons.add,
      onPressed: () {
        Get.dialog(AddTextDialog());
      },
    ),
    EditOption(title: 'Font\nsize', icon: Icons.text_increase, onPressed: () {}),
    EditOption(title: 'Font\ncolor', icon: Icons.format_color_text, onPressed: () {}),
    EditOption(title: 'Back\ncolor', icon: Icons.format_color_fill, onPressed: () {}),
    EditOption(title: 'Text\nposition', icon: Icons.align_vertical_center, onPressed: () {}),
    EditOption(title: 'Text\nstart', icon: Icons.start, onPressed: () {}),
    EditOption(title: 'Text\nduration', icon: Icons.timer, onPressed: () {}),
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
      width: MediaQuery.of(context).size.width,
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
              case SelectedOptions.TEXT:
                options = textOptions;
              default:
                options = baseVideoOptions;
            }

            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _.selectedOptions != SelectedOptions.BASE
                        ? InkWell(
                            onTap: () {
                              if (_.selectedOptions == SelectedOptions.TRIM) {
                                // Jump to the start of the video / trim start.
                                _.jumpToStart();
                              }
                              _.selectedOptions = SelectedOptions.BASE;
                            },
                            child: SizedBox(
                              width: 40.0,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    _.selectedOptions == SelectedOptions.BASE ? SizedBox(width: 12.0) : SizedBox(width: 8.0),
                    ...options.map((option) {
                      return Row(children: [
                        EditActionButton(
                          onPressed: option.onPressed,
                          icon: option.icon,
                          text: option.title,
                        ),
                        _.selectedOptions == SelectedOptions.BASE ? SizedBox(width: 12.0) : SizedBox(width: 8.0),
                      ]);
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showTrackVolumeDialog() {}
}
