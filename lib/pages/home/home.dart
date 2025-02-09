// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/controllers/projects_controller.dart';
import 'package:flutter_video_editor/controllers/settings_controller.dart';
import 'package:flutter_video_editor/pages/home/widgets/project_card.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/core/constants.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;
import 'package:flutter_video_editor/shared/widgets/help_button.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Scaffold(
        appBar: _topBar(context),
        body: TabBarView(
          children: [
            _projectsList(context),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.NEW_PROJECT),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  _topBar(BuildContext context) {
    return AppBar(
      title: Text(translations.homePageTitle.tr, style: Theme.of(context).textTheme.titleLarge),
      actions: [
        HelpButton(),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () {
            Get.toNamed(Routes.SETTINGS);
          },
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
              Tab(text: translations.homePageTabTitle.tr),
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
            ? _.projects.isEmpty && !_.isCreatingProject
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translations.homePageTitleNoProjects.tr,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          translations.homePageSubtitleNoProjects.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _.projects.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0 && _.isCreatingProject) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              height: 100.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          );
                        } else if (index != 0) {
                          return Padding(
                            padding: index == _.projects.length ? EdgeInsets.only(bottom: 64.0) : EdgeInsets.zero,
                            child: ProjectCard(project: _.projects[index - 1]),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(translations.homePageLoadingProjects.tr, style: Theme.of(context).textTheme.bodySmall),
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
                    translations.homePageLogInButton.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
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
                    translations.homePageLogoutSubtitle.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _.user!.displayName!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
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
                      showSnackbar(
                        CustomColors.info,
                        translations.homepageLogoutSnackbarTitle.tr,
                        translations.homepageLogoutSnackbarMessage.tr,
                        Icons.logout_outlined,
                      );
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      translations.homePageLogoutButtonText.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
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
