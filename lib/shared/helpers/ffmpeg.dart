import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';

String generateFFMPEGCommand(
    String inputPath, String outputPath, int msVideoDuration, MediaTransformations transformations) {
  // Base command
  String command = '-i $inputPath';

  // Add trim command
  command +=
      getTrimCommand(transformations.trimStart.inMilliseconds, transformations.trimEnd.inMilliseconds, msVideoDuration);

  // Add end command
  command += '-c:v mpeg4 $outputPath';

  // command += '-c:v libx264 -c:a aac -strict experimental $outputPath';

  return command;
}

String getTrimCommand(int msTrimStart, int msTrimEnd, int msVideoDuration) {
  String command = ' ';

  if (msTrimStart > 0) {
    command += '-ss ${msToFFMPEGTime(msTrimStart)} ';
  }

  if (msTrimEnd < msVideoDuration) {
    command += '-to ${msToFFMPEGTime(msTrimEnd)} ';
  }

  return command;
}

String msToFFMPEGTime(int milliseconds) {
  int ms = milliseconds % 1000;
  int seconds = (milliseconds / 1000).floor();
  int minutes = (seconds / 60).floor();
  int hours = (minutes / 60).floor();

  seconds = seconds % 60;
  minutes = minutes % 60;

  String msString = convertThree(ms);
  String secondsString = convertTwo(seconds);
  String minutesString = convertTwo(minutes);
  String hoursString = convertTwo(hours);

  return '$hoursString:$minutesString:$secondsString.$msString';
}
