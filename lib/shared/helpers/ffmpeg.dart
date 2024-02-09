import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';

String generateFFMPEGCommand(
    String inputPath, String outputPath, int msVideoDuration, MediaTransformations transformations) {
  final hasAudio = transformations.audioUrl.isNotEmpty;

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

  // Add end command
  command += ' -map [v0] -map ${hasAudio ? '[audio_out]' : '[a0]'} -c:v mpeg4 $outputPath';

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
