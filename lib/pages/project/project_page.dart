import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/controllers/new_project_controller.dart';
import 'package:flutter_video_editor/pages/project/widgets/footer.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({Key? key});

  final NewProjectController _newProjectController = Get.put(NewProjectController());

  // Used to control the text being edited.
  final _edtNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When the user taps the container, unfocus the text field.
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _appBar(context),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              GetBuilder<GoogleSignInController>(
                builder: (_) {
                  return _.isUserSignedIn
                      ? SizedBox.shrink()
                      : Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: CustomColors.warning,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.warning_amber_outlined,
                                color: CustomColors.onWarning,
                                size: 30.0,
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text("Projects won't be saved if you are not logged in with Google",
                                    style:
                                        Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.onWarning)),
                              ),
                            ],
                          ),
                        );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [..._content(context)],
                    ),
                  ),
                ),
              ),
              NewProjectFooter(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onBackground),
              onPressed: () => Get.back(),
              splashRadius: 24,
            ),
            SizedBox(width: 8),
            Text('New Project', style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context) {
    return [
      SizedBox(
        height: 8.0,
      ),
      TextField(
        controller: _edtNameController,
        style: Theme.of(context).textTheme.titleMedium,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          labelText: 'Project name',
          labelStyle: Theme.of(context).textTheme.bodySmall,
          suffixIcon: IconButton(
            onPressed: () {
              _edtNameController.clear();
            },
            icon: Icon(Icons.cancel_outlined),
            splashRadius: 20.0,
          ),
          border: OutlineInputBorder(),
        ),
        onChanged: (String val) => _newProjectController.projectName = val,
      ),
      SizedBox(height: 24.0),
      Text('Media:', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
      SizedBox(height: 8.0),
      GetBuilder<NewProjectController>(
        builder: (_) {
          return _.isMediaEmpty
              ? Text('Select media from camera or gallery', style: Theme.of(context).textTheme.bodySmall)
              : _displayMedia(context, _.media!);
        },
      ),
      _pickMediaButtons(context),
      GetBuilder<NewProjectController>(builder: (_) {
        if (_.isMediaImage) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0),
              Text('Photo duration:',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
              Slider(
                value: _.photoDuration.toDouble(),
                min: 1,
                max: 16,
                divisions: 15,
                label: '${_.photoDuration.toString()} seconds',
                onChanged: (double value) {
                  _.photoDuration = value.toInt();
                },
              ),
            ],
          );
        } else {
          // Do not display photo duration for videos
          return SizedBox.shrink();
        }
      })
    ];
  }

  Widget _pickMediaButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        ElevatedButton.icon(
          onPressed: () {
            Get.dialog(Dialog(
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Media type', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 16.0),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                              borderRadius: BorderRadius.circular(100.0),
                            )),
                        onPressed: () {
                          _newProjectController.pickImageFromCamera();
                          Get.back();
                        },
                        icon: Icon(Icons.image_outlined),
                        label: Text('Image'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        onPressed: () {
                          _newProjectController.pickVideoFromCamera();
                          Get.back();
                        },
                        icon: Icon(Icons.video_library_outlined),
                        label: Text('Video'),
                      ),
                    ])
                  ],
                ),
              ),
            ));
          },
          icon: Icon(Icons.camera_outlined),
          label: Text('Pick media from camera'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColorLight,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
        SizedBox(height: 12.0),
        ElevatedButton.icon(
          onPressed: () {
            _newProjectController.pickMediaFromGallery();
          },
          icon: Icon(Icons.photo_library_outlined),
          label: Text('Pick media from gallery'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColorLight,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayMedia(BuildContext context, XFile media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isImage(media.path) ? _imageContainer(context, media) : _videoContainer(context),
        SizedBox(height: 24.0),
        Text('Change media:', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _imageContainer(BuildContext context, XFile media) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          image: FileImage(File(media.path)),
          fit: BoxFit.cover,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: ColoredIconButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _newProjectController.clearMedia();
              },
              icon: Icons.clear,
            ),
          )
        ],
      ),
    );
  }

  Widget _videoContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).colorScheme.onBackground,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GetBuilder<NewProjectController>(
            builder: (_) {
              return InkWell(
                onTap: () {
                  _.isVideoPlaying ? _.pauseVideo() : _.playVideo();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: _.isVideoInitialized ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: AspectRatio(
                      aspectRatio: _.videoAspectRatio,
                      child: VideoPlayer(_.videoController!),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: GetBuilder<NewProjectController>(
                  builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _.jump5Backward(),
                          icon: Icon(Icons.replay_5_outlined, color: Colors.white),
                        ),
                        SizedBox(width: 4.0),
                        _.isVideoPlaying
                            ? IconButton(
                                onPressed: () => _.pauseVideo(),
                                icon: Icon(Icons.pause_rounded, color: Colors.white),
                              )
                            : IconButton(
                                onPressed: () => _.playVideo(),
                                icon: Icon(Icons.play_arrow_rounded, color: Colors.white),
                              ),
                        SizedBox(width: 4.0),
                        IconButton(
                          onPressed: () => _.jump5Foward(),
                          icon: Icon(Icons.forward_5_outlined, color: Colors.white),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 15,
            child: GetBuilder<NewProjectController>(
              builder: (_) {
                return Row(
                  children: [
                    Text(
                      '${convertTwo(_.videoPosition[0])}:${convertTwo(_.videoPosition[1])}',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    Text(
                      '/${_.videoDuration}',
                      style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                    )
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ColoredIconButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _newProjectController.clearMedia();
              },
              icon: Icons.clear,
            ),
          )
        ],
      ),
    );
  }
}
