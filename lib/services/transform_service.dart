import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/log.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:ffmpeg_kit_flutter_full/session.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';

class TransformService {
  // Executes FFMPEG command to turn image to a video with a photo duration
  Future<String> imageToVideo(String inputPath, int photoDuration) async {
    // Generate the output path
    String filename = inputPath.split('/').last.split('.').first;
    String outputPath = await generateOutputPath(filename);

    print('Image to video: $inputPath -> $outputPath');
    // FFMPEG command
    String command = '-loop 1 -i $inputPath -t $photoDuration -filter:v scale=720:-2 -y -c:v mpeg4 $outputPath';
    Session session = await FFmpegKit.execute(command);
    ReturnCode? returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print('Image to video success');
      return outputPath;
    } else {
      print('Image to video error: ${session.getAllLogs()}');
      List<Log> logs = await session.getAllLogs();
      for (Log log in logs) {
        print('Log: ${log.getMessage()}');
      }
      return '';
    }
  }
}
