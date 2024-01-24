import 'package:flutter/material.dart';

class VideoTimeline extends StatefulWidget {
  final double videoDuration;
  final double currentVideoPosition;
  final Function(double) onPositionChanged;

  VideoTimeline({
    required this.videoDuration,
    required this.currentVideoPosition,
    required this.onPositionChanged,
  });

  @override
  VideoTimelineState createState() => VideoTimelineState();
}

class VideoTimelineState extends State<VideoTimeline> {
  final ScrollController _scrollController = ScrollController();
  double _indicatorPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.0, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (widget.videoDuration / 1).ceil(), // Assuming each segment represents 10 seconds
            controller: _scrollController,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width /
                    (widget.videoDuration / 1).ceil(), // Adjust the width of each segment as needed
                decoration: BoxDecoration(
                  color: _isSegmentActive(index) ? Colors.blue : Colors.grey,
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              double newPosition = _indicatorPosition + details.primaryDelta!;
              newPosition = newPosition.clamp(0.0, MediaQuery.of(context).size.width);
              _indicatorPosition = newPosition;
              double videoPosition = (_indicatorPosition / MediaQuery.of(context).size.width) * widget.videoDuration;
              widget.onPositionChanged(videoPosition);
            });
          },
          child: Container(
            height: 20.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                height: 15.0,
                width: 15.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSegmentActive(int index) {
    double segmentStartTime = index * 1; // Assuming each segment represents 10 seconds
    double segmentEndTime = (index + 1) * 1;
    return (widget.currentVideoPosition >= segmentStartTime && widget.currentVideoPosition < segmentEndTime);
  }

  @override
  void didUpdateWidget(covariant VideoTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Scroll to the current video position when it changes
    _scrollController.jumpTo(widget.currentVideoPosition * _getScrollFactor());
    _updateIndicatorPosition();
  }

  void _updateIndicatorPosition() {
    setState(() {
      _indicatorPosition = (widget.currentVideoPosition / widget.videoDuration) * MediaQuery.of(context).size.width;
    });
  }

  double _getScrollFactor() {
    return MediaQuery.of(context).size.width / widget.videoDuration;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
