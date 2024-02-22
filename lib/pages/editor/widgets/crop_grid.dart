import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/editor_controller.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
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
                  painter: CropGridPainter(_.cropAspectRatio),
                  child: SizedBox(
                    height: _.cropHeight,
                    width: _.cropWidth,
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
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropHeight = _.cropHeight * _.scalingFactor;
                    _.initialCropX = _.cropX;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    _.updateTopLeft(details.localPosition);

                    _.cropWidth = (_.initialCropWidth - ((_.cropX - _.initialCropX) * _.scalingFactor))
                        .clamp(0.0, double.infinity);
                    _.cropHeight = (_.initialCropHeight - ((_.cropY - _.initialCropY) * _.scalingFactor))
                        .clamp(0.0, double.infinity);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // -------------- Top Center ------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY - 15,
                left: _.cropX + (_.cropWidth / 2) - 15,
                child: GestureDetector(
                  key: _.topKey,
                  onPanStart: (details) {
                    _.initY = _.globalTopPosition.dy - _.globalCropPosition.dy;
                    _.initialCropHeight = _.cropHeight * _.scalingFactor;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    if (_.cropAspectRatio == CropAspectRatio.FREE) {
                      _.cropY = (details.localPosition.dy + _.initY)
                          .clamp(0.0, (_.initialCropHeight / _.scalingFactor + _.initialCropY))
                          .toDouble();
                      _.cropHeight = (_.initialCropHeight - ((_.cropY - _.initialCropY) * _.scalingFactor))
                          .clamp(0.0, double.infinity);
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // -------------- Top Right -------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY - 15,
                left: _.cropX + _.cropWidth - 15,
                child: GestureDetector(
                  key: _.rightTopKey,
                  onPanStart: (details) {
                    _.initX = _.globalTopRightPosition.dx - _.globalCropPosition.dx;
                    _.initY = _.globalTopRightPosition.dy - _.globalCropPosition.dy;
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropHeight = _.cropHeight * _.scalingFactor;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    // _.cropWidth = ((details.localPosition.dx + _.initX - _.cropX) * _.scalingFactor)
                    //     .clamp(0.0, _.videoWidth - _.cropX * _.scalingFactor)
                    //     .toDouble();
                    // _.cropY = (details.localPosition.dy + _.initY)
                    //     .clamp(0.0, (_.initialCropHeight / _.scalingFactor + _.initialCropY))
                    //     .toDouble();
                    _.updateTopRight(details.localPosition);
                    _.cropHeight = (_.initialCropHeight - ((_.cropY - _.initialCropY) * _.scalingFactor))
                        .clamp(0.0, double.infinity);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),

              // --------------------------------------------
              // ------------ Center Left  ------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + (_.cropHeight / 2) - 15,
                left: _.cropX - 15,
                child: GestureDetector(
                  key: _.leftKey,
                  onPanStart: (details) {
                    _.initX = _.globalLeftPosition.dx - _.globalCropPosition.dx;
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropX = _.cropX;
                  },
                  onPanUpdate: (details) {
                    if (_.cropAspectRatio == CropAspectRatio.FREE) {
                      _.cropX = (details.localPosition.dx + _.initX)
                          .clamp(0.0, _.initialCropWidth / _.scalingFactor + _.initialCropX)
                          .toDouble();
                      _.cropWidth = (_.initialCropWidth - ((_.cropX - _.initialCropX) * _.scalingFactor))
                          .clamp(0.0, double.infinity);
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // ---------------- Center --------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + (_.cropHeight / 2) - 15,
                left: _.cropX + (_.cropWidth / 2) - 15,
                child: GestureDetector(
                  key: _.centerKey,
                  onPanStart: (details) {
                    _.initX = _.globalCenterPosition.dx - _.globalCropPosition.dx;
                    _.initY = _.globalCenterPosition.dy - _.globalCropPosition.dy;
                    _.initialCropX = _.cropX;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    _.cropX = (details.localPosition.dx + _.initX - _.cropWidth / 2)
                        .clamp(0.0, (_.videoWidth - (_.cropWidth * _.scalingFactor)) / _.scalingFactor)
                        .toDouble();
                    _.cropY = (details.localPosition.dy + _.initY - _.cropHeight / 2)
                        .clamp(0.0, (_.videoHeight - (_.cropHeight * _.scalingFactor)) / _.scalingFactor)
                        .toDouble();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // ------------ Center Right ------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + (_.cropHeight / 2) - 15,
                left: _.cropX + _.cropWidth - 15,
                child: GestureDetector(
                  key: _.rightKey,
                  onPanStart: (details) {
                    _.initX = _.globalRightPosition.dx - _.globalCropPosition.dx;
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropX = _.cropX;
                  },
                  onPanUpdate: (details) {
                    if (_.cropAspectRatio == CropAspectRatio.FREE) {
                      _.cropWidth = ((details.localPosition.dx + _.initX - _.cropX) * _.scalingFactor)
                          .clamp(0.0, _.videoWidth - _.cropX * _.scalingFactor)
                          .toDouble();
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // ------------ Bottom Left -------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + _.cropHeight - 15,
                left: _.cropX - 15,
                child: GestureDetector(
                  key: _.leftBottomKey,
                  onPanStart: (details) {
                    _.initX = _.globalLeftBottomPosition.dx - _.globalCropPosition.dx;
                    _.initY = _.globalLeftBottomPosition.dy - _.globalCropPosition.dy;
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropX = _.cropX;
                  },
                  onPanUpdate: (details) {
                    _.cropX = (details.localPosition.dx + _.initX)
                        .clamp(0.0, _.initialCropWidth / _.scalingFactor + _.initialCropX)
                        .toDouble();
                    _.cropWidth = (_.initialCropWidth - ((_.cropX - _.initialCropX) * _.scalingFactor))
                        .clamp(0.0, double.infinity);
                    _.cropHeight = ((details.localPosition.dy + _.initY - _.cropY) * _.scalingFactor)
                        .clamp(0.0, _.videoHeight - _.cropY * _.scalingFactor)
                        .toDouble();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // ------------ Bottom Center -----------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + _.cropHeight - 15,
                left: _.cropX + (_.cropWidth / 2) - 15,
                child: GestureDetector(
                  key: _.bottomKey,
                  onPanStart: (details) {
                    _.initY = _.globalBottomPosition.dy - _.globalCropPosition.dy;
                    _.initialCropHeight = _.cropHeight * _.scalingFactor;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    if (_.cropAspectRatio == CropAspectRatio.FREE) {
                      _.cropHeight = ((details.localPosition.dy + _.initY - _.cropY) * _.scalingFactor)
                          .clamp(0.0, _.videoHeight - _.cropY * _.scalingFactor)
                          .toDouble();
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // --------------------------------------------
              // ------------ Bottom Right ------------------
              // --------------------------------------------
              Positioned(
                top: _.cropY + _.cropHeight - 15,
                left: _.cropX + _.cropWidth - 15,
                child: GestureDetector(
                  key: _.rightBottomKey,
                  onPanStart: (details) {
                    _.initX = _.globalBottomRightPosition.dx - _.globalCropPosition.dx;
                    _.initY = _.globalBottomRightPosition.dy - _.globalCropPosition.dy;
                    _.initialCropWidth = _.cropWidth * _.scalingFactor;
                    _.initialCropHeight = _.cropHeight * _.scalingFactor;
                    _.initialCropX = _.cropX;
                    _.initialCropY = _.cropY;
                  },
                  onPanUpdate: (details) {
                    _.cropWidth = ((details.localPosition.dx + _.initX - _.cropX) * _.scalingFactor)
                        .clamp(0.0, _.videoWidth - _.cropX * _.scalingFactor)
                        .toDouble();
                    _.cropHeight = ((details.localPosition.dy + _.initY - _.cropY) * _.scalingFactor)
                        .clamp(0.0, _.videoHeight - _.cropY * _.scalingFactor)
                        .toDouble();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
