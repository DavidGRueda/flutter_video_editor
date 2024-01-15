import 'package:flutter/material.dart';
import 'package:flutter_video_editor/models/project.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/widgets/colored_icon_button.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => {print('Project tapped ${project.name} ${project.id}')},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: AssetImage(project.media.path),
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
                      Text('Last edited: ${project.lastUpdated}',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
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