import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.question_circle, size: 26.0),
      color: Theme.of(context).colorScheme.onBackground,
      onPressed: () async {
        await launchUrl(Uri.parse(Constants.guideUrl));
      },
      splashRadius: 20.0,
    );
  }
}
