import 'package:flutter/material.dart';

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
