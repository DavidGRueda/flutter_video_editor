import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/helpers/files.dart';
import 'package:flutter_video_editor/shared/helpers/video.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  // Used to display the thumbnail if it's a video
  Uint8List? _videoThumbnail;

  @override
  void initState() {
    super.initState();
    if (isVideo(widget.project.media.path)) {
      getVideoThumbnail(widget.project.media).then((value) => setState(() => _videoThumbnail = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => {print('Project tapped ${widget.project.name} ${widget.project.id} ${widget.project.media.path}')},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: isImage(widget.project.media.path)
                  ? Image.file(File(widget.project.media.path)).image
                  : _videoThumbnail != null
                      ? Image.memory(_videoThumbnail!).image
                      : AssetImage('assets/placeholder.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last edited: ${widget.project.lastUpdated}',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                      Text(
                        widget.project.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.edit_outlined,
                        onPressed: () {},
                      ),
                      SizedBox(height: 8.0),
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.download_outlined,
                        onPressed: () {},
                      ),
                      SizedBox(height: 8.0),
                      ColoredIconButton(
                        backgroundColor: CustomColors.iconButtonBackground,
                        icon: Icons.delete_outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 