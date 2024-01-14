import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/pages/home/widgets/project_card.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  // ignore: unused_field
  final _projectsController = Get.put(ProjectsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: _topBar(context),
        body: TabBarView(
          children: [
            _projectsList(context),
            Center(child: Text('Drafts')),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => Get.toNamed('/new-project'),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  _topBar(BuildContext context) {
    return AppBar(
      title: Text('My projects', style: Theme.of(context).textTheme.titleMedium),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: () {},
          splashRadius: 20.0,
        ),
        SizedBox(width: 8.0),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight - 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            padding: EdgeInsets.only(left: 16.0),
            isScrollable: true,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            tabs: [
              Tab(text: 'Recent projects'),
              Tab(text: 'Drafts'),
            ],
          ),
        ),
      ),
    );
  }

  _projectsList(BuildContext context) {
    return GetBuilder<ProjectsController>(
      builder: (_) {
        return _.projectsLoaded
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _.projects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(project: _.projects[index]);
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading projects...'),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      strokeWidth: 2.0,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
