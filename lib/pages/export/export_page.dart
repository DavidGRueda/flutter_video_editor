// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/export_controller.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/widgets/social_media_button.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

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
        body: _exportController.isExporting.value
            ? _loadingScreen(context)
            : _exportController.errorExporting.value
                ? _errorExportingVideoScreen(context)
                : _exportedVideoScreen(context),
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
      () => WillPopScope(
        onWillPop: () async => false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(translations.exportPageLoadingTitle.tr,
                style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                translations.exportPageLoadingSubtitle.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
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
      ),
    );
  }

  _exportedVideoScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 40.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(translations.exportPageSuccessTitle.tr,
                    style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                Image.asset(
                  'assets/check.png',
                  height: MediaQuery.of(context).size.width / 2.5,
                  width: MediaQuery.of(context).size.width / 2.5,
                ),
                Text(
                  translations.exportPageShareMessage.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.0),
                _socialMediaShareButtons(context)
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.until((route) => Get.currentRoute == Routes.HOME),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            child: Text(
              translations.exportPageGoHome.tr,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  _socialMediaShareButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SocialMediaButton(
            imageUrl: 'assets/instagram_icon.png',
            title: 'Instagram\nStories',
            onPressed: () => _exportController.shareToSocialMedia(SocialMedia.INSTAGRAM),
          ),
          SocialMediaButton(
            imageUrl: 'assets/facebook_icon.png',
            title: 'Facebook\nStories',
            onPressed: () => _exportController.shareToSocialMedia(SocialMedia.FACEBOOK),
          ),
          SocialMediaButton(
            imageUrl: 'assets/whatsapp_icon.png',
            title: 'WhatsApp',
            onPressed: () => _exportController.shareToSocialMedia(SocialMedia.WHATSAPP),
          ),
          SocialMediaButton(
            imageUrl: 'assets/other_icon.png',
            title: translations.exportPageOtherOptions.tr,
            onPressed: () => _exportController.shareToSocialMedia(SocialMedia.OTHER),
          ),
        ],
      ),
    );
  }

  _errorExportingVideoScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 40.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(translations.exportPageErrorTitle.tr,
                    style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                SizedBox(height: 18.0),
                Image.asset(
                  'assets/error.png',
                  height: MediaQuery.of(context).size.width / 2.5,
                  width: MediaQuery.of(context).size.width / 2.5,
                ),
                SizedBox(height: 18.0),
                Text(
                  translations.exportPageErrorSubtitle.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight.withOpacity(0.1),
                      border: Border.all(color: Theme.of(context).primaryColorLight, width: 2.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            translations.exportPageErrorLogsTitle.tr,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8.0),
                          for (var log in _exportController.logs)
                            Text(
                              log.getMessage(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          SizedBox(height: 18.0),
                          Text(
                            translations.exportPageErrorCommandTitle.tr,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _exportController.command,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.0)
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.until((route) => Get.currentRoute == Routes.HOME),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            child: Text(
              translations.exportPageGoHome.tr,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
