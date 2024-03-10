import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/pages/editor/widgets/crop_grid.dart';
import 'package:flutter_video_editor/pages/editor/widgets/dialogs/edit_text_dialog.dart';
import 'package:flutter_video_editor/pages/editor/widgets/timelines/audio_timeline.dart';
import 'package:flutter_video_editor/pages/editor/widgets/editor_actions.dart';
import 'package:flutter_video_editor/pages/editor/widgets/export_bottom_sheet.dart';
import 'package:flutter_video_editor/pages/editor/widgets/timelines/text_timeline.dart';
import 'package:flutter_video_editor/pages/editor/widgets/timelines/video_timeline.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditorPage extends StatelessWidget {
  EditorPage({super.key});

  // ignore: unused_field
  final _editorController = Get.put(EditorController(project: Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _editorAppBar(context),
      body: GetBuilder<EditorController>(
        builder: (_) {
          return Column(
            children: [
              _videoPlayer(context),
              _videoControls(context),
              SizedBox(height: 16.0),
              _videoTimeline(context),
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    if (_.selectedOptions != SelectedOptions.BASE) {
                      _.selectedOptions = SelectedOptions.BASE;
                      _.selectedTextId = '';
                    }
                  },
                ),
              ),
              EditorActions()
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _editorAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      titleSpacing: 0,
      shape: RoundedRectangleBorder(),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Get back to project page row
            InkWell(
              onTap: () => Get.back(),
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              child: Row(
                children: [
                  Icon(Icons.keyboard_backspace, color: Theme.of(context).colorScheme.onBackground, size: 26.0),
                  SizedBox(width: 4.0),
                  Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.onBackground, size: 26.0),
                ],
              ),
            ),
            // Project save and export row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.cloud_upload_outlined, size: 26.0),
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {
                    // Save the project transformations to the database
                    ProjectsController.to.saveProjectTransformations(_editorController.project);
                  },
                  splashRadius: 20.0,
                ),
                IconButton(
                  icon: Icon(Icons.file_upload_outlined, size: 26.0),
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  splashRadius: 20.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _videoPlayer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Colors.black,
          ),
          child: GetBuilder<EditorController>(
            builder: (_) {
              return _videoContainer();
            },
          )),
    );
  }

  _videoContainer() {
    return GetBuilder<EditorController>(
      builder: (_) {
        return InkWell(
          onTap: () {
            if (_.selectedOptions != SelectedOptions.CROP) {
              _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _.isVideoInitialized ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: AspectRatio(
                aspectRatio: _.videoAspectRatio,
                child: _.isVideoInitialized
                    ? Stack(
                        children: [
                          VideoPlayer(_.videoController!),
                          _.isCropped && _.selectedOptions != SelectedOptions.CROP
                              ? CustomPaint(
                                  painter: CropPainter(
                                    x: _.cropX,
                                    y: _.cropY,
                                    width: _.cropWidth,
                                    height: _.cropHeight,
                                  ),
                                  child: SizedBox(
                                    height: _.videoHeight * _.scalingFactor,
                                    width: _.videoWidth * _.scalingFactor,
                                  ))
                              : SizedBox.shrink(),
                          ..._.nTexts > 0
                              ? _.texts.map((TextTransformation text) {
                                  if (text.shouldDisplay(_.msVideoPosition)) return _getTextOverlay(text);
                                  return SizedBox.shrink();
                                }).toList()
                              : [SizedBox.shrink(), SizedBox.shrink()],
                          _.selectedOptions == SelectedOptions.CROP ? CropGrid() : SizedBox.shrink(),
                        ],
                      )
                    : SizedBox(),
              ),
            ),
          ),
        );
      },
    );
  }

  _videoControls(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: GetBuilder<EditorController>(
          builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Video position text
                Row(
                  children: [
                    Text(
                      _.videoPositionString,
                      style:
                          Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '/${_.videoDurationString}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.35), width: 2.0),
                  ),
                  height: 30.0,
                  width: 30.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
                    },
                    icon: _.isVideoPlaying ? Icon(Icons.pause_sharp) : Icon(Icons.play_arrow),
                    splashRadius: 16.0,
                  ),
                ),
                // Other controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.undo_outlined),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.redo_outlined),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.fullscreen_outlined),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ));
  }

  _videoTimeline(BuildContext context) {
    return GetBuilder<EditorController>(builder: (_) {
      return Stack(
        children: [
          CustomPaint(
            painter: LinePainter(_.videoPosition),
            child: Container(
              height: 85.0,
            ),
          ),
          Column(
            children: [
              // Video Timeline
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _.scrollController,
                child: Column(
                  children: [
                    // -------------------------------
                    //        Video Timeline (secs)
                    // -------------------------------
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                        ...List.generate(
                          _.videoDuration.toInt(),
                          (index) => Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2), width: 1.0),
                                bottom: BorderSide(
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2), width: 1.0),
                              ),
                            ),
                            width: 50.0, // Adjust the width of each timeline item
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Transform.translate(
                                      offset: Offset(-5.0, 0.0),
                                      child: Text(
                                        '$index',
                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                              overflow: TextOverflow.visible,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      height: 6.0,
                                      width: 2.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(2.0),
                                      )),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    VideoTimeline(),
                    SizedBox(height: 12.0),
                    AudioTimeline(),
                    SizedBox(height: 12.0),
                    TextTimeline()
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  _showBottomSheet(BuildContext context) {
    Get.bottomSheet(
      ExportBottomSheet(),
      enterBottomSheetDuration: Duration(milliseconds: 175),
      exitBottomSheetDuration: Duration(milliseconds: 175),
    );
  }

  Widget _getTextOverlay(TextTransformation text) {
    final [MainAxisAlignment rowAlignment, MainAxisAlignment columnAlignment] =
        getTextAlignmentFromPosition(text.position);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: columnAlignment,
        children: [
          Row(
            mainAxisAlignment: rowAlignment,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    if (_editorController.selectedOptions != SelectedOptions.TEXT) {
                      _editorController.selectedOptions = SelectedOptions.TEXT;
                    }
                    _editorController.selectedTextId = text.id;
                  },
                  onLongPress: () {
                    _editorController.selectedTextId = text.id;
                    Get.dialog(EditTextDialog());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: text.backgroundColor != '' ? Color(int.parse(text.backgroundColor)) : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        text.text,
                        softWrap: true,
                        style: TextStyle(
                          color: Color(int.parse(text.color)),
                          fontSize: text.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
