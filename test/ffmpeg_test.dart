import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_editor/models/media_transformations.dart';
import 'package:flutter_video_editor/shared/helpers/ffmpeg.dart';

void main() {
  group('FFMPEG commands', () {
    group('Get FFMPEG time', () {
      test('should convert a millisecond time in FFMPEG time format', () {
        int ms0 = 77;
        int ms1 = 500;
        int ms2 = 66000;
        int ms3 = 4853200;
        expect(msToFFMPEGTime(ms0), '00:00:00.077');
        expect(msToFFMPEGTime(ms1), '00:00:00.500');
        expect(msToFFMPEGTime(ms2), '00:01:06.000');
        expect(msToFFMPEGTime(ms3), '01:20:53.200');
      });
    });

    group('Trim command', () {
      test('should return an empty string if no trim was set', () {
        int msTrimStart = 0;
        int msTrimEnd = 1000;
        int msVideoDuration = 1000;
        expect(getTrimCommand(msTrimStart, msTrimEnd, msVideoDuration), ' ');
      });

      test('should return a trim start command if a trim start was set', () {
        int msTrimStart = 6520;
        int msTrimEnd = 10000;
        int msVideoDuration = 10000;
        expect(getTrimCommand(msTrimStart, msTrimEnd, msVideoDuration), ' -ss 00:00:06.520 ');
      });

      test('should return a trim end command if a trim end was set', () {
        int msTrimStart = 0;
        int msTrimEnd = 6520;
        int msVideoDuration = 10000;
        expect(getTrimCommand(msTrimStart, msTrimEnd, msVideoDuration), ' -to 00:00:06.520 ');
      });

      test('should return a trim start and trim end command if both were set', () {
        int msTrimStart = 1000;
        int msTrimEnd = 6520;
        int msVideoDuration = 10000;
        expect(getTrimCommand(msTrimStart, msTrimEnd, msVideoDuration), ' -ss 00:00:01.000 -to 00:00:06.520 ');
      });
    });

    group('Generate FFMPEG command', () {
      test('should generate a valid FFMPEG command', () {
        String inputPath = 'input.mp4';
        String outputPath = 'output.mp4';
        int msVideoDuration = 10000;
        MediaTransformations transformations = MediaTransformations();
        transformations.trimEnd = Duration(milliseconds: 10000);

        expect(generateFFMPEGCommand(inputPath, outputPath, msVideoDuration, transformations),
            '-i input.mp4 -c:v mpeg4 output.mp4');
      });

      test('should generate a valid FFMPEG command with trim command', () {
        String inputPath = 'input.mp4';
        String outputPath = 'output.mp4';
        int msVideoDuration = 10000;
        MediaTransformations transformations = MediaTransformations();
        transformations.trimStart = Duration(milliseconds: 1000);
        transformations.trimEnd = Duration(milliseconds: 6520);

        expect(
          generateFFMPEGCommand(inputPath, outputPath, msVideoDuration, transformations),
          '-i input.mp4 -ss 00:00:01.000 -to 00:00:06.520 -c:v mpeg4 output.mp4',
        );
      });
    });
  });
}
