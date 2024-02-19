import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:flutter_video_editor/models/text.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:path_provider/path_provider.dart';

Future<String> registerFonts() async {
  const filename = 'CenturyGothic-Regular.ttf';
  var bytes = await rootBundle.load("fonts/$filename");

  String dir = (await getApplicationDocumentsDirectory()).path;
  final path = '$dir/$filename';

  final buffer = bytes.buffer;
  await File(path).writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

  File file = File('$dir/$filename');

  print('Loaded file ${file.path}');
  FFmpegKitConfig.setFontDirectoryList(["/system/fonts", "/System/Library/Fonts", file.path]);

  return file.path;
}

Future<String> generateFFMPEGCommand(
  String inputPath,
  String outputPath,
  int msVideoDuration,
  MediaTransformations transformations,
  double fontScalingFactor,
) async {
  final hasAudio = transformations.audioUrl.isNotEmpty;
  final hasTexts = transformations.texts.isNotEmpty;

  // Base command
  String command = '-i $inputPath ${hasAudio ? '-i ${transformations.audioUrl} ' : ''}';

  // Add trim command
  command += getFilterComplexTrimCommand(
    transformations.trimStart.inMilliseconds,
    transformations.trimEnd.inMilliseconds,
    msVideoDuration,
    transformations.masterVolume,
  );

  // Add volume command
  command += getFilterComplexAudioCommand(
    hasAudio,
    transformations.audioVolume,
    transformations.audioStart.inMilliseconds,
  );

  // Add text command. Get font path
  final fontPath = await registerFonts();
  command += getFilterComplexTextCommand(
      hasTexts, transformations.texts, transformations.trimStart.inMilliseconds, fontPath, fontScalingFactor);

  // Add end command
  command +=
      ' -map ${hasTexts ? '[video_out]' : '[v0]'} -map ${hasAudio ? '[audio_out]' : '[a0]'} -c:v mpeg4 $outputPath';

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

  return '$hoursString\\\\\\:$minutesString\\\\\\:$secondsString.$msString';
}

String getFilterComplexTrimCommand(int msTrimStart, int msTrimEnd, int msVideoDuration, double masterVolume) {
  String command = '';
  command +=
      '-filter_complex [0:v]trim=start=${msToFFMPEGTime(msTrimStart)}:end=${msToFFMPEGTime(msTrimEnd)},setpts=PTS-STARTPTS[v0];';
  command +=
      '[0:a]atrim=start=${msToFFMPEGTime(msTrimStart)}:end=${msToFFMPEGTime(msTrimEnd)},asetpts=PTS-STARTPTS,volume=$masterVolume[a0]';
  return command;
}

String getFilterComplexAudioCommand(bool hasAudio, double audioVolume, int msAudioStart) {
  String command = '';

  // If there is no audio, return empty string
  if (!hasAudio) {
    return command;
  }

  // Configure the audio that will be merged with the video
  command += ';[1:a]atrim=start=${msToFFMPEGTime(msAudioStart)},volume=$audioVolume,asetpts=PTS-STARTPTS[a1];';

  // Combine the two audios
  command += '[a0][a1]amix=inputs=2:duration=first[audio_out]';

  return command;
}

String getFilterComplexTextCommand(
  bool hasTexts,
  List<TextTransformation> texts,
  int msTrimStart,
  String fontPath,
  double fontScalingFactor,
) {
  String command = '';

  if (!hasTexts) {
    return command;
  }

  command += ';[v0]';

  for (var i = 0; i < texts.length; i++) {
    final text = texts[i];

    // Add the text, font size and color
    command +=
        'drawtext=text=\'${text.text}\':fontsize=${text.fontSize * fontScalingFactor}:fontcolor=${convertColorToFFMPEGColor(text.color)}:fontfile=\'$fontPath\'';

    // If the text has a background color, add it
    if (text.backgroundColor != '') {
      command += ':box=1:boxcolor=${convertColorToFFMPEGColor(text.backgroundColor)}:boxborderw=10';
    }

    // Add position
    command += ':${convertTextPositionToFFMPEGPosition(text.position, fontScalingFactor)}';

    // Add start and end time
    command +=
        ':enable=between(t\\,${msToSeconds(text.msStartTime - msTrimStart)}\\,${msToSeconds(text.msStartTime + text.msDuration - msTrimStart)})';

    // If it's not the last text, add a comma. Else, add the output
    if (i != texts.length - 1) {
      command += ',';
    } else {
      command += '[video_out]';
    }
  }

  return command;
}

String msToSeconds(int milliseconds) {
  return (milliseconds / 1000).toStringAsFixed(3);
}

// Takes alpha component and moves it to the end of the string
String convertColorToFFMPEGColor(String color) {
  return '0x${color.substring(4)}${color.substring(2, 4)}';
}

String convertTextPositionToFFMPEGPosition(TextPosition position, double fontScalingFactor) {
  List<String> tp = position.toString().split('.').last.split('');
  String vp = tp[0];
  String hp = tp[1];

  String padding = (fontScalingFactor * 12.0).toInt().toString();

  String finalVPosition = vp == 'T'
      ? padding
      : vp == 'M'
          ? '(main_h/2-text_h/2)'
          : '(main_h-text_h)-$padding';
  String finalHPosition = hp == 'L'
      ? padding
      : hp == 'C'
          ? '(main_w/2-text_w/2)'
          : '(main_w-text_w)-$padding';

  return 'x=$finalHPosition:y=$finalVPosition';
}
