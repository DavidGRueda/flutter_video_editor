import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/log.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:ffmpeg_kit_flutter_full/session.dart';
import 'package:ffmpeg_kit_flutter_full/statistics.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/core/keys.dart';
import 'package:flutter_video_editor/shared/helpers/ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class ExportController extends GetxController {
  static ExportController get to => Get.find();

  final String command;
  final String outputPath;
  final int videoDuration; // In milliseconds
  RxBool isExporting = true.obs;
  RxBool isSavingToGallery = true.obs;
  RxBool errorExporting = false.obs;
  RxDouble exportProgress = 0.0.obs;
  List<Log> logs = [];

  AppinioSocialShare appSS = AppinioSocialShare();

  ExportController({required this.command, required this.outputPath, required this.videoDuration});

  @override
  void onInit() async {
    super.onInit();

    // Register fonts
    await registerFonts();

    // Start the export process
    _exportVideo();
  }

  _exportVideo() async {
    // Execute the export command. Save the video to the gallery if the export is successful.
    await FFmpegKit.executeAsync(command, (Session session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        isExporting.value = false;
        GallerySaver.saveVideo(outputPath)
            .then((saved) => saved != null && saved ? isSavingToGallery.value = false : true);
      } else if (ReturnCode.isCancel(returnCode)) {
        print('VIDEO EXPORT CANCELLED ${session.getLogsAsString()}');
      } else {
        // There was an error exporting the video
        logs = await session.getLogs();
        for (var element in logs) {
          print('${element.getMessage()}\n');
        }
        isExporting.value = false;
        errorExporting.value = true;
      }
    }, (Log log) {
      print('${log.getMessage()}\n');
    }, (Statistics statistics) {
      if (statistics.getTime() > 0) {
        exportProgress.value = statistics.getTime() / videoDuration;
        print('Progress: ${exportProgress.value * 100}%');
      }
    });
  }

  shareToSocialMedia(SocialMedia socialMedia) async {
    switch (socialMedia) {
      case SocialMedia.FACEBOOK:
        await appSS.shareToFacebookStory(APIKeys.facebookAppId, backgroundVideo: outputPath);
      case SocialMedia.WHATSAPP:
        await appSS.shareToWhatsapp('', filePaths: [outputPath]);
      case SocialMedia.INSTAGRAM:
        await appSS.shareToInstagramStory(APIKeys.facebookAppId, backgroundVideo: outputPath);
      case SocialMedia.OTHER:
        await appSS.shareToSystem(translations.shareYourVideoMessage.tr, '', filePaths: [outputPath]);
    }
  }
}
