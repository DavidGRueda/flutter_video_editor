// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/export_controller.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:percent_indicator/circular_percent_indicator.dart';

class ExportPage extends StatelessWidget {
  final ExportController _exportController = Get.put(
    ExportController(
      command: Get.arguments['command'],
      outputPath: Get.arguments['outputPath'],
      videoDuration: Get.arguments['videoDuration'],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // Hide the app bar when exporting the video.
        appBar: _exportController.isExporting.value ? null : _exportAppBar(context),
        body: _exportController.isExporting.value ? _loadingScreen(context) : Center(child: Text('Exported!')),
      ),
    );
  }

  _exportAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      titleSpacing: 0,
      shape: RoundedRectangleBorder(),
      title: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: Icon(
                      Icons.cut,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 26.0,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              // Navigate to the projects page without removing the Google Sign In and Projects controllers
              onTap: () => Get.until((route) => Get.currentRoute == Routes.HOME),
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              child: Row(
                children: [
                  Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.onBackground, size: 26.0),
                  SizedBox(width: 4.0),
                  Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 26.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadingScreen(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Exporting the video", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Text(
            "Please do not close the app until\nthe video is fully exported",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          CircularPercentIndicator(
            radius: 60.0,
            animateFromLastPercent: true,
            progressColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
            circularStrokeCap: CircularStrokeCap.round,
            percent: _exportController.exportProgress.value,
            center: Text(
              '${(_exportController.exportProgress.value * 100).toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
