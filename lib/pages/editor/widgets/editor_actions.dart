import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/models/edit_option.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/add_text_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/audio_start_sheet.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/edit_text_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/font_color_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/font_size_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/set_start_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/text_duration_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/text_position_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/track_volume_dialog.dart';
import 'package:flutter_video_editor/shared/core/CustomIcons_icons.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:flutter_video_editor/shared/widgets/edit_action_button.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class EditorActions extends StatelessWidget {
  // Base video options that will be displayed in the editor.
  final List<EditOption> baseVideoOptions = [
    EditOption(
      title: translations.baseVideoTrimTitle.tr,
      icon: Icons.cut_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.TRIM;
      },
    ),
    EditOption(
      title: translations.baseVideoAudioTitle.tr,
      icon: Icons.music_note_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.AUDIO;
      },
    ),
    EditOption(
      title: translations.baseVideoTextTitle.tr,
      icon: Icons.text_fields_outlined,
      onPressed: () {
        EditorController.to.selectedOptions = SelectedOptions.TEXT;
      },
    ),
    EditOption(
        title: translations.baseVideoCropTitle.tr,
        icon: Icons.crop,
        onPressed: () {
          EditorController.to.selectedOptions = SelectedOptions.CROP;
        }),
  ];

  final List<EditOption> trimOptions = [
    EditOption(
      title: translations.trimOptionsTrimStart.tr,
      icon: CustomIcons.trimEnd,
      onPressed: () {
        EditorController.to.setTrimStart();
      },
    ),
    EditOption(
      title: translations.trimOptionsTrimEnd.tr,
      icon: CustomIcons.trimStart,
      onPressed: () {
        EditorController.to.setTrimEnd();
      },
    ),
    EditOption(
      title: translations.trimOptionsJumpBack.tr,
      icon: Icons.replay,
      onPressed: () {
        EditorController.to.jumpBack50ms();
      },
    ),
    EditOption(
      title: translations.trimOptionsJumpForward.tr,
      icon: CustomIcons.forward,
      onPressed: () {
        EditorController.to.jumpForward50ms();
      },
    ),
  ];

  final List<EditOption> audioOptions = [
    EditOption(
      title:
          EditorController.to.hasAudio ? translations.audioOptionsChangeAudio.tr : translations.audioOptionsAddAudio.tr,
      icon: Icons.add,
      onPressed: () {
        EditorController.to.pickAudio();
      },
    ),
    EditOption(
      title: translations.audioOptionsRemoveAudio.tr,
      icon: Icons.remove_circle_outline,
      onPressed: () {
        EditorController.to.removeAudio();
      },
    ),
    EditOption(
        title: translations.audioOptionsTrackVolume.tr,
        icon: Icons.volume_up_outlined,
        onPressed: () {
          Get.dialog(TrackVolumeDialog());
        }),
    EditOption(
        title: translations.audioOptionsAudioStart.tr,
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
              translations.audioOptionsAudioStartErrorTitle.tr,
              EditorController.to.hasAudio
                  ? translations.audioOptionsAudioStartErrorSubtitleSmallerDuration.tr
                  : translations.audioOptionsAudioStartErrorSubtitleNoAudio.tr,
              Icons.error_outline,
            );
          }
        }),
  ];

  final List<EditOption> textOptions = [
    EditOption(
      title: translations.textOptionsAddText.tr,
      icon: Icons.add,
      onPressed: () {
        Get.dialog(AddTextDialog());
      },
    ),
    EditOption(
      title: translations.textOptionsEditText.tr,
      icon: Icons.edit_outlined,
      onPressed: () {
        if (EditorController.to.selectedTextId != '') {
          Get.dialog(EditTextDialog());
        } else {
          showSnackbar(
            CustomColors.error,
            translations.textOptionsNoSelectedTextErrorTitle.tr,
            translations.textOptionsEditTextError.tr,
            Icons.error_outline,
          );
        }
      },
    ),
    EditOption(
      title: translations.textOptionsFontSize.tr,
      icon: Icons.text_increase,
      onPressed: () {
        if (EditorController.to.selectedTextId != '') {
          Get.dialog(FontSizeDialog());
        } else {
          showSnackbar(
            CustomColors.error,
            translations.textOptionsNoSelectedTextErrorTitle.tr,
            translations.textOptionsFontSizeError.tr,
            Icons.error_outline,
          );
        }
      },
    ),
    EditOption(
      title: translations.textOptionsFontColor.tr,
      icon: Icons.format_color_text,
      onPressed: () {
        if (EditorController.to.selectedTextId != '') {
          Get.dialog(FontColorDialog(
            context: ColorPickerContext.TEXT,
          ));
        } else {
          showSnackbar(
            CustomColors.error,
            translations.textOptionsNoSelectedTextErrorTitle.tr,
            translations.textOptionsFontColorError.tr,
            Icons.error_outline,
          );
        }
      },
    ),
    EditOption(
        title: translations.textOptionsBackgroundColor.tr,
        icon: Icons.format_color_fill,
        onPressed: () {
          if (EditorController.to.selectedTextId != '') {
            Get.dialog(FontColorDialog(
              context: ColorPickerContext.BACKGROUND,
            ));
          } else {
            showSnackbar(
              CustomColors.error,
              translations.textOptionsNoSelectedTextErrorTitle.tr,
              translations.textOptionsBackgroundColorError.tr,
              Icons.error_outline,
            );
          }
        }),
    EditOption(
      title: translations.textOptionsTextPosition.tr,
      icon: Icons.align_vertical_center,
      onPressed: () {
        if (EditorController.to.selectedTextId != '') {
          Get.dialog(TextPositionDialog());
        } else {
          showSnackbar(
            CustomColors.error,
            translations.textOptionsNoSelectedTextErrorTitle.tr,
            translations.textOptionsTextPositionError.tr,
            Icons.error_outline,
          );
        }
      },
    ),
    EditOption(
        title: translations.textOptionsTextStart.tr,
        icon: Icons.start,
        onPressed: () {
          if (EditorController.to.selectedTextId != '') {
            if (EditorController.to.isTooCloseToEnd) {
              showSnackbar(
                CustomColors.error,
                translations.textOptionsTextStartTooCloseTitleError.tr,
                translations.textOptionsTextStartTooCloseSubtitleError.tr,
                Icons.error_outline,
              );
            } else if (EditorController.to.newStartWillOverlap) {
              Get.dialog(
                SetStartDialog(),
                barrierDismissible: false,
              );
            } else {
              EditorController.to.setTextStart();
            }
          } else {
            showSnackbar(
              CustomColors.error,
              translations.textOptionsNoSelectedTextErrorTitle.tr,
              translations.textOptionsTextStartError.tr,
              Icons.error_outline,
            );
          }
        }),
    EditOption(
      title: translations.textOptionsTextDuration.tr,
      icon: Icons.timer,
      onPressed: () {
        if (EditorController.to.selectedTextId != '') {
          Get.dialog(TextDurationDialog());
        } else {
          showSnackbar(
            CustomColors.error,
            translations.textOptionsNoSelectedTextErrorTitle.tr,
            translations.textOptionsTextDurationError.tr,
            Icons.error_outline,
          );
        }
      },
    ),
    EditOption(
        title: translations.textOptionsDeleteText.tr,
        icon: Icons.delete_outline,
        onPressed: () {
          EditorController.to.deleteSelectedText();
        }),
  ];

  final List<EditOption> cropOptions = [
    EditOption(
      title: translations.cropOptionsFreeForm.tr,
      icon: Icons.crop,
      onPressed: () {
        EditorController.to.setCropAspectRatio(CropAspectRatio.FREE);
      },
    ),
    EditOption(
      title: '1:1\n${translations.cropOptionsCrop.tr}',
      icon: CustomIcons.instagram,
      onPressed: () {
        EditorController.to.setCropAspectRatio(CropAspectRatio.SQUARE);
      },
    ),
    EditOption(
      title: '16:9\n${translations.cropOptionsCrop.tr}',
      icon: CustomIcons.youtube,
      onPressed: () {
        EditorController.to.setCropAspectRatio(CropAspectRatio.RATIO_16_9);
      },
    ),
    EditOption(
      title: '9:16\n${translations.cropOptionsCrop.tr}',
      icon: CustomIcons.youtube,
      onPressed: () {
        EditorController.to.setCropAspectRatio(CropAspectRatio.RATIO_9_16);
      },
    ),
    EditOption(
      title: '4:5\n${translations.cropOptionsCrop.tr}',
      icon: CustomIcons.facebook,
      onPressed: () {
        EditorController.to.setCropAspectRatio(CropAspectRatio.RATIO_4_5);
      },
    ),
    EditOption(
      title: translations.cropOptionsReset.tr,
      icon: Icons.refresh,
      onPressed: () {
        EditorController.to.resetCrop();
      },
    )
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
              case SelectedOptions.CROP:
                options = cropOptions;
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

                              if (_.selectedOptions == SelectedOptions.TEXT) {
                                // Reset the selected text id.
                                _.selectedTextId = '';
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
