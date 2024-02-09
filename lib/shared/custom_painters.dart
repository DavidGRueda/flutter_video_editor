import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinePainter extends CustomPainter {
  final double videoPosition;

  LinePainter(this.videoPosition);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    // Draw a vertical line at the center
    canvas.drawLine(Offset(size.width / 2, -5), Offset(size.width / 2, size.height), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TrimPainter extends CustomPainter {
  final int msTrimStart;
  final int msTrimEnd;

  TrimPainter(this.msTrimStart, this.msTrimEnd);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the x-coordinates for trim start and trim end lines
    double startX = (msTrimStart / 1000) * 50.0;
    double endX = (msTrimEnd / 1000) * 50.0;

    endX = endX.clamp(0.0, size.width);
    // Draw trim start line only if it's not at the beginning
    if (startX > 0) {
      drawRoundedRectangleWithOpacity(canvas, 0.0, startX, Colors.black.withOpacity(0.15), size, true);
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX, size.height),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0,
      );

      drawTriangle(
        canvas,
        Offset(startX, 1),
        Colors.red,
        false, // pointing down
      );
    }

    // Draw trim end line only if it's not at the end
    if (endX < size.width) {
      canvas.drawLine(
        Offset(endX, 0),
        Offset(endX, size.height),
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2.0,
      );

      drawTriangle(
        canvas,
        Offset(endX, 1),
        Colors.blue,
        false,
      );
      drawRoundedRectangleWithOpacity(canvas, endX, size.width, Colors.black.withOpacity(0.15), size, false);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is TrimPainter) {
      return msTrimStart != oldDelegate.msTrimStart || msTrimEnd != oldDelegate.msTrimEnd;
    }
    return true;
  }

  void drawTriangle(Canvas canvas, Offset position, Color color, bool pointingDown) {
    final path = Path();
    const triangleHeight = 6.0;

    if (pointingDown) {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx - triangleHeight, position.dy + triangleHeight);
      path.lineTo(position.dx + triangleHeight, position.dy + triangleHeight);
    } else {
      path.moveTo(position.dx, position.dy);
      path.lineTo(position.dx - triangleHeight, position.dy - triangleHeight);
      path.lineTo(position.dx + triangleHeight, position.dy - triangleHeight);
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void drawRoundedRectangleWithOpacity(Canvas canvas, double start, double end, Color color, Size size, bool isStart) {
    final radius = Radius.circular(10.0);
    final rect = RRect.fromRectAndCorners(
      Rect.fromPoints(Offset(start, 0), Offset(end, size.height)),
      topLeft: isStart ? radius : Radius.zero,
      topRight: isStart ? Radius.zero : radius,
      bottomLeft: isStart ? radius : Radius.zero,
      bottomRight: isStart ? Radius.zero : radius,
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}

class DragHandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Theme.of(Get.context!).colorScheme.onBackground.withOpacity(0.2)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    const double handleWidth = 60.0;
    const double handleHeight = 6.0;

    // Draw the rounded rectangle handle
    final RRect handleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: handleWidth,
        height: handleHeight,
      ),
      Radius.circular(handleHeight / 2),
    );
    canvas.drawRRect(handleRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RoundedProgressBarPainter extends CustomPainter {
  final double msMaxAudioDuration;
  final double currentPosition;

  RoundedProgressBarPainter({
    required this.msMaxAudioDuration,
    required this.currentPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(Get.context!).primaryColorLight // Color of the progress bar
      ..style = PaintingStyle.fill;

    double progressBarHeight = 40.0;
    double borderRadius = progressBarHeight / 4;
    double progressBarWidth = (msMaxAudioDuration / 1000) * 12.0; // 12 pixels per second

    // Adjust the y-coordinate to position the bars at the bottom of the container
    double startY = size.height - progressBarHeight + 6.0;

    // Draw the background bar with border
    RRect backgroundBar = RRect.fromLTRBR(
      0,
      startY,
      progressBarWidth,
      size.height,
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(backgroundBar, Paint()..color = Colors.transparent);

    // Draw the progress bar with border
    double progressWidth = (currentPosition / msMaxAudioDuration) * progressBarWidth;
    RRect progressBar = RRect.fromLTRBR(
      0,
      startY,
      progressWidth,
      size.height,
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(progressBar, paint);

    Paint borderPaint = Paint()
      ..color = Colors.black // Color of the border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Width of the border
    canvas.drawRRect(backgroundBar, borderPaint);
  }

  @override
  bool shouldRepaint(covariant RoundedProgressBarPainter oldDelegate) {
    return oldDelegate.msMaxAudioDuration != msMaxAudioDuration || oldDelegate.currentPosition != currentPosition;
  }
}
