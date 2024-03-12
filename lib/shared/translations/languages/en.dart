import '../translation_keys.dart' as translation;

class En {
  Map<String, String> get messages => {
        translation.projectLastEdited: 'Last edited: ',
        translation.deleteDialogTitle: 'Delete project?',
        translation.deleteDialogMessage: 'This action cannot be undone. Are you sure you want to delete the project?',
        translation.deleteDialogCancel: 'Cancel',
        translation.deleteDialogDelete: 'Delete',
        translation.editDialogTitle: 'Edit project',
        translation.editDialogLabelText: 'ProjectName',
        translation.editDialogCancel: 'Cancel',
        translation.editDialogSave: 'Save',

        translation.homePageTitle: 'My Projects',
        translation.homePageTabTitle: 'Recent projects',
        translation.homePageTitleNoProjects: 'Create new projects!',
        translation.homePageSubtitleNoProjects: "You can create new projects by clicking on the '+' button below.",
        translation.homePageLoadingProjects: 'Loading projects...',
        translation.homePageLogInButton: 'Log in',
        translation.homePageLogoutSubtitle: 'You are logged in as',
        translation.homepageLogoutSnackbarTitle: 'Logging out',
        translation.homepageLogoutSnackbarMessage: 'You have been logged out from your Google account',
        translation.homePageLogoutButtonText: 'Log out',

        // New project page keys
        translation.newProjectFooterCancel: 'Cancel',
        translation.newProjectFooterStartEditing: 'Start editing',
        translation.newProjectSnackbarTitle: 'Creating project...',
        translation.newProjectSnackbarMessage: 'Your project is being created',

        translation.newProjectTitle: 'New project',
        translation.newProjectNotLoggedWarning: "Projects won't be saved if you are not logged in with Google",
        translation.newProjectNameLabel: 'Project name',
        translation.newProjectMediaTitle: 'Media:',
        translation.newProjectNoMediaSubtitle: 'Select media from camera or gallery',
        translation.newProjectPhotoDurationTitle: 'Photo duration:',
        translation.newProjectMediaTypeTitle: 'Media type',
        translation.newProjectMediaTypeImage: 'Image',
        translation.newProjectMediaTypeVideo: 'Video',
        translation.newProjectPickMediaCamera: 'Pick media from camera',
        translation.newProjectPickMediaGallery: 'Pick media from gallery',
        translation.newProjectChangeMedia: 'Change media:',

        // Editor page keys
        translation.addTextDialogTitle: 'Add new text',
        translation.addTextDialogMessage: 'The text will be added in the current video position',
        translation.addTextDialogLabel: 'Text to add',
        translation.addTextDialogDuration: 'Text duration',
        translation.addTextDialogCancel: 'Cancel',
        translation.addTextDialogSave: 'Save',
        translation.editTextDialogTitle: 'Edit text',
        translation.editTextDialogLabel: 'Edited text',
        translation.fontColorDialogTitle: 'Select font color',
        translation.backgroundColorDialogTitle: 'Select background color',
        translation.backgroundColorDialogClear: 'Clear',
        translation.fontSizeDialogTitle: 'Set font size',
        translation.fontSizeDialogSubtitle: 'Font size',
        translation.selectTextDialogTitle: 'Select the text to edit',
        translation.setStartDialogTitle: 'Adjust text duration',
        translation.setStartDialogSubtitle:
            'The text duration is too long for the media. Do you want the duration to be adjusted?',
        translation.setStartDialogCancel: 'Cancel',
        translation.setStartDialogAdjust: 'Adjust duration',
        translation.setTextDurationTitle: 'Set text duration',
        translation.setTextPositionTitle: 'Set text position',
        translation.setTrackVolumeTitle: 'Set track volume',
        translation.setTrackVolumeMasterLabel: 'Master\nvolume',
        translation.setTrackVolumeAudioLabel: 'Audio\nvolume',
        translation.audioTimelineAddAudio: 'Add audio!',
        translation.textTimelineAddText: 'Add text!',
        translation.audioStartSheetTitle: 'Audio start',

        // -- Editor options
        translation.baseVideoTrimTitle: 'Trim',
        translation.baseVideoAudioTitle: 'Audio',
        translation.baseVideoTextTitle: 'Text',
        translation.baseVideoCropTitle: 'Crop',
        translation.trimOptionsTrimStart: 'Set trim\nstart',
        translation.trimOptionsTrimEnd: 'Set trim\nend',
        translation.trimOptionsJumpBack: 'Jump\nback',
        translation.trimOptionsJumpForward: 'Jump\nfoward',
        translation.audioOptionsAddAudio: 'Add\naudio',
        translation.audioOptionsChangeAudio: 'Change\naudio',
        translation.audioOptionsRemoveAudio: 'Remove\naudio',
        translation.audioOptionsTrackVolume: 'Track\nvolume',
        translation.audioOptionsAudioStart: 'Set audio\nstart',
        translation.audioOptionsAudioStartErrorTitle: 'Cannot set audio start',
        translation.audioOptionsAudioStartErrorSubtitleNoAudio: 'No audio has been added to the video',
        translation.audioOptionsAudioStartErrorSubtitleSmallerDuration:
            'The audio duration is smaller than the video duration',
        translation.textOptionsAddText: 'Add\ntext',
        translation.textOptionsNoSelectedTextErrorTitle: 'No text selected',
        translation.textOptionsEditText: 'Edit\ntext',
        translation.textOptionsEditTextError: 'Please select a text to edit its content.',
        translation.textOptionsFontSize: 'Font\nsize',
        translation.textOptionsFontSizeError: 'Please select a text to change the font size.',
        translation.textOptionsFontColor: 'Font\ncolor',
        translation.textOptionsFontColorError: 'Please select a text to change the font color.',
        translation.textOptionsBackgroundColor: 'Back\ncolor',
        translation.textOptionsBackgroundColorError: 'Please select a text to change the background color.',
        translation.textOptionsTextPosition: 'Text\nposition',
        translation.textOptionsTextPositionError: 'Please select a text to change the position.',
        translation.textOptionsTextDuration: 'Text\nduration',
        translation.textOptionsTextDurationError: 'Please select a text to set the duration.',
        translation.textOptionsTextStart: 'Text\nstart',
        translation.textOptionsTextStartTooCloseTitleError: 'Text too close to end',
        translation.textOptionsTextStartTooCloseSubtitleError:
            'Cannot set the start of the text 100ms or less from the end of the video.',
        translation.textOptionsTextStartError: 'Please select a text to set the start.',
        translation.textOptionsDeleteText: 'Delete\ntext',
        translation.cropOptionsFreeForm: 'Free\nform',
        translation.cropOptionsCrop: 'crop',
        translation.cropOptionsReset: 'Reset\ncrop',

        // Export page keys
        translation.exportPageLoadingTitle: 'Exporting the video',
        translation.exportPageLoadingSubtitle: 'Please do not close the app until\nthe video is fully exported',
        translation.exportPageSuccessTitle: 'The video was exported successfully',
        translation.exportPageShareMessage: 'Share the video in',
        translation.exportPageGoHome: 'Return to the main page',
        translation.exportPageOtherOptions: 'Other',
        translation.exportPageErrorTitle: 'Oops!\nSomething went wrong!',
        translation.exportPageErrorSubtitle: 'There was some error exporting the video. Please try again.',
        translation.exportPageErrorLogsTitle: 'Error logs',
        translation.exportPageErrorCommandTitle: 'Command executed',

        // Settings page keys
        translation.settingsPageTitle: 'Settings',
        translation.settingsPageLanguageTitle: 'Select language',
        translation.settingsPageThemeTitle: 'Theme',

        // Controller keys
        // -- Editor
        translation.deniedOperationErrorTitle: "Denied operation",
        translation.setTrimStartErrorMessage: 'Cannot set the trim start after the trim end',
        translation.setTrimEndErrorMessage: 'Cannot set the trim end before the trim start',
        translation.noAudioToRemoveErrorMessage: 'No audio to remove',
        translation.cannotDeleteTextErrorTitle: 'Cannot delete text',
        translation.cannotDeleteTextErrorMessage: 'No text is selected. Select a text to delete.',

        // -- Export
        translation.shareYourVideoMessage: 'Share your video!',

        // -- New project
        translation.errorAddingProjectTitle: 'Error adding the project',
        translation.errorAddingProjectMessage: 'There was an error adding the project. Please try again.',

        // -- Projects
        translation.projectCreatedSuccessTitle: 'Project created!',
        translation.projectCreatedLocalSuccessMessage: 'Your project was created successfully',
        translation.projectCreatedAndSavedToCloudSuccessMessage:
            'Your project was created and saved to the cloud successfully',
        translation.projectSavedToCloudSuccessTitle: 'Project saved!',
        translation.projectSavedToCloudSuccessMessage: 'Your project was saved in the cloud successfully',
        translation.projectSignInToSaveTitle: 'Sign in to save your project',
        translation.projectSignInToSaveMessage: 'You need to sign in to save your project to the cloud',
      };
}
