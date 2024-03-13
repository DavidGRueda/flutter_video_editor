import 'package:flutter/material.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';

class ColoredIconButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;

  ColoredIconButton({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: Icon(icon, color: CustomColors.textLight),
        onPressed: onPressed,
        splashRadius: 20.0,
      ),
    );
  }
}
