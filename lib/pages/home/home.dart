import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/pages/home/widgets/project_card.dart';
import 'package:flutter_video_editor/shared/colors.dart';
import 'package:flutter_video_editor/shared/constants.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
        _googleSignIn(context),
        SizedBox(width: 8.0)
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
      init: ProjectsController(),
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

  _googleSignIn(BuildContext context) {
    return GetBuilder<GoogleSignInController>(
      init: GoogleSignInController(),
      builder: (_) {
        return _.user != null
            ? SizedBox(
                child: InkWell(
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_.user!.photoURL ?? Constants.fallbackImage),
                      radius: 16.0,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _.signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Log in',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              );
      },
    );
  }

  _showLogoutDialog(BuildContext context) {
    return Get.dialog(
      GetBuilder<GoogleSignInController>(
        builder: (_) {
          return Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_.user!.photoURL ?? Constants.fallbackImage),
                    radius: 32.0,
                  ),
                  SizedBox(height: 8.0),
                  Text(_.user!.email!, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey)),
                  SizedBox(height: 16.0),
                  Text(
                    'You are logged in as',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    _.user!.displayName!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.error,
                    ),
                    onPressed: () async {
                      Get.back();
                      await Future.delayed(Duration(milliseconds: 300)); // Wait the dialog is fully closed
                      _.signOutFromGoogle();
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Log out',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
