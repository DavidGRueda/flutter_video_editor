import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onPressed;
  final String title;

  const SocialMediaButton({
    required this.imageUrl,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: InkWell(
            onTap: onPressed,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            child: Image.asset(imageUrl),
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 12.0,
              ),
        ),
      ],
    );
  }
}
