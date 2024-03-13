import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';
import 'package:gallery_saver/files.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  get projectLastUpdated => DateFormat('dd.MM.yyyy').format(project.lastUpdated);
  get isLocalThumbnail => isLocalFilePath(project.thumbnailUrl);

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Get.isDarkMode ? Colors.white : Colors.transparent,
          width: 2.0,
        ),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          print('Project tapped ${project.name} ${project.projectId}');
          Get.toNamed(Routes.EDITOR, arguments: project);
        },
        child: isLocalThumbnail ? _localThumbnailCard(context) : _networkThumbnailCard(context),
      ),
    );
  }

  _localThumbnailCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          image: project.thumbnailUrl != ''
              ? Image.memory(File(project.thumbnailUrl).readAsBytesSync()).image
              : Image.asset('assets/placeholder.jpeg').image,
          fit: BoxFit.cover,
        ),
      ),
      child: _cardContent(context),
    );
  }

  _networkThumbnailCard(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: project.thumbnailUrl,
        imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: _cardContent(context),
            ),
        placeholder: (context, url) => _loadingThumbnailCard(context),
        errorWidget: (context, url, error) => _loadingThumbnailCard(context));
  }

  _loadingThumbnailCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          image: Image.asset('assets/placeholder.jpeg').image,
          fit: BoxFit.cover,
        ),
      ),
      child: _cardContent(context),
    );
  }

  _cardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${translations.projectLastEdited.tr} $projectLastUpdated',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColoredIconButton(
                    backgroundColor: CustomColors.iconButtonBackground,
                    icon: Icons.edit_outlined,
                    onPressed: () {
                      _showEditDialog(context);
                    },
                  ),
                  SizedBox(height: 8.0),
                  // ColoredIconButton(
                  //   backgroundColor: CustomColors.iconButtonBackground,
                  //   icon: Icons.download_outlined,
                  //   onPressed: () {},
                  // ),
                  // SizedBox(height: 8.0),
                  ColoredIconButton(
                    backgroundColor: CustomColors.iconButtonBackground,
                    icon: Icons.delete_outlined,
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
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
                Text(translations.deleteDialogTitle.tr, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16.0),
                Text(
                  translations.deleteDialogMessage.tr,
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
                      child: Text(translations.deleteDialogCancel.tr,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        ProjectsController.to.deleteProject(project.projectId);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text(translations.deleteDialogDelete.tr,
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
    final nameCtrl = TextEditingController(text: project.name);

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
                Text(translations.editDialogTitle.tr, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 24.0),
                TextField(
                  controller: nameCtrl,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: translations.editDialogLabelText.tr,
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
                      child: Text(translations.editDialogCancel.tr,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        ProjectsController.to.updateProject(project.projectId, ProjectEdits(nameCtrl.text));
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text(translations.editDialogSave.tr,
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
