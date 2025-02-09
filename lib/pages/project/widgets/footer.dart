import 'package:flutter/material.dart';
import 'package:flutter_video_editor/controllers/google_sign_in_controller.dart';
import 'package:flutter_video_editor/controllers/new_project_controller.dart';
import 'package:flutter_video_editor/shared/core/colors.dart';
import 'package:flutter_video_editor/shared/helpers/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class NewProjectFooter extends StatelessWidget {
  const NewProjectFooter({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 2.0),
                  borderRadius: BorderRadius.circular(100.0),
                )),
            onPressed: () {
              Get.back();
            },
            child: Text(translations.newProjectFooterCancel.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: GetBuilder<NewProjectController>(
              builder: (_) {
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    disabledBackgroundColor: Theme.of(context).disabledColor,
                    disabledForegroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: _.isMediaEmpty ? Theme.of(context).disabledColor : Theme.of(context).primaryColorLight,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onPressed: !(_.isMediaEmpty)
                      ? () {
                          _.createProject();
                          Get.back();
                          if (GoogleSignInController.to.isUserSignedIn) {
                            showSnackbar(
                              CustomColors.info,
                              translations.newProjectSnackbarTitle.tr,
                              translations.newProjectSnackbarMessage.tr,
                              Icons.settings_outlined,
                            );
                          }
                        }
                      : null,
                  icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
                  label: Text(
                    translations.newProjectFooterStartEditing.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
