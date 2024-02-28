import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with AutomaticKeepAliveClientMixin {
  // Used to display the thumbnail if it's a video
  Uint8List? _videoThumbnail;

  get projectMediaPath => widget.project.mediaUrl;
  get projectLastUpdated => DateFormat('dd.MM.yyyy').format(widget.project.lastUpdated);

  @override
  void initState() {
    super.initState();
    if (isVideo(projectMediaPath)) {
      if (isNetworkPath(projectMediaPath)) {
        getNetworkVideoThumbnail(projectMediaPath)
            .then((value) => setState(() => _videoThumbnail = File(value!).readAsBytesSync()));
      } else {
        getLocalVideoThumbnail(projectMediaPath).then((value) => setState(() => _videoThumbnail = value));
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          print('Project tapped ${widget.project.name} ${widget.project.projectId}');
          Get.toNamed(Routes.EDITOR, arguments: widget.project);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: _videoThumbnail != null
                  ? Image.memory(_videoThumbnail!).image
                  : AssetImage('assets/placeholder.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last edited: $projectLastUpdated',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                      Text(
                        widget.project.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.edit_outlined,
                        onPressed: () {
                          _showEditDialog(context);
                        },
                      ),
                      SizedBox(height: 8.0),
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.download_outlined,
                        onPressed: () {},
                      ),
                      SizedBox(height: 8.0),
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.delete_outlined,
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showDeleteDialog(BuildContext context) {
    Get.dialog(
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete project?', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16.0),
                Text(
                  'This action cannot be undone. Are you sure you want to delete the project?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 24.0),
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
                      onPressed: () {
                        ProjectsController.to.deleteProject(widget.project.projectId);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text('Delete',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  _showEditDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: widget.project.name);

    Get.dialog(
      GestureDetector(
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
                Text('Edit project', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 24.0),
                TextField(
                  controller: nameCtrl,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Project name',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    suffixIcon: IconButton(
                      onPressed: () {
                        nameCtrl.clear();
                      },
                      icon: Icon(Icons.cancel_outlined),
                      splashRadius: 20.0,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
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
                      onPressed: () {
                        ProjectsController.to.updateProject(widget.project.projectId, ProjectEdits(nameCtrl.text));
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text('Save',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

//
