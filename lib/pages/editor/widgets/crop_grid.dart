import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:get/get.dart';

class CropGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return CustomPaint(
          painter: CropGridPainter(),
          child: Container(
            width: _.cropWidth.toDouble(),
            height: _.cropHeight.toDouble(),
          ),
        );
      },
    );
  }
}
