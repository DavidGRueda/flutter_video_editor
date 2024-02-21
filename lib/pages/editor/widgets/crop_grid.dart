import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/custom_painters.dart';
import 'package:get/get.dart';

class CropGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditorController>(
      builder: (_) {
        return SizedBox(
          child: Stack(
            key: _.cropKey,
            children: [
              Positioned(
                top: _.cropY,
                left: _.cropX,
                child: CustomPaint(
                  painter: CropGridPainter(),
                  child: SizedBox(
                    height: _.cropHeight.toDouble(),
                    width: _.cropWidth.toDouble(),
                  ),
                ),
              ),
              // --------------------------------------------
              // -------------- Top Left --------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY - 15,
                left: _.cropX - 15,
                child: GestureDetector(
                  key: _.leftTopKey,
                  onPanStart: (details) {
                    _.initX = _.globalLeftTopPosition.dx - _.globalCropPosition.dx;
                    _.initY = _.globalLeftTopPosition.dy - _.globalCropPosition.dy;
                  },
                  onPanUpdate: (details) {
                    _.cropX =
                        (details.localPosition.dx + _.initX).clamp(0.0, _.scalingFactor * _.videoWidth).toDouble();
                    _.cropY =
                        (details.localPosition.dy + _.initY).clamp(0.0, _.scalingFactor * _.videoHeight).toDouble();

                    _.cropWidth = (_.videoWidth - (_.cropX * _.scalingFactor)).toInt();
                    _.cropHeight = (_.videoHeight - (_.cropY * _.scalingFactor)).toInt();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
