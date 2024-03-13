import '../translation_keys.dart' as translation;

class It {
  Map<String, String> get messages => {
        translation.projectLastEdited: 'Ultima modifica: ',
        translation.deleteDialogTitle: 'Eliminare il progetto?',
        translation.deleteDialogMessage:
            'Questa azione non può essere annullata. Sei sicuro di voler eliminare il progetto?',
        translation.deleteDialogCancel: 'Annulla',
        translation.deleteDialogDelete: 'Elimina',
        translation.editDialogTitle: 'Modifica progetto',
        translation.editDialogLabelText: 'Nome del progetto',
        translation.editDialogCancel: 'Annulla',
        translation.editDialogSave: 'Salva',

        translation.homePageTitle: 'I miei progetti',
        translation.homePageTabTitle: 'Progetti recenti',
        translation.homePageTitleNoProjects: 'Crea nuovi progetti!',
        translation.homePageSubtitleNoProjects: 'Puoi creare nuovi progetti cliccando sul pulsante "+" qui sotto.',
        translation.homePageLoadingProjects: 'Caricamento progetti...',
        translation.homePageLogInButton: 'Accedi',
        translation.homePageLogoutSubtitle: 'Hai effettuato l\'accesso come',
        translation.homepageLogoutSnackbarTitle: 'Disconnessione',
        translation.homepageLogoutSnackbarMessage: 'Hai effettuato la disconnessione dal tuo account Google',
        translation.homePageLogoutButtonText: 'Disconnettiti',

        // New project page keys
        translation.newProjectFooterCancel: 'Annulla',
        translation.newProjectFooterStartEditing: 'Inizia modifica',
        translation.newProjectSnackbarTitle: 'Creazione progetto...',
        translation.newProjectSnackbarMessage: 'Il tuo progetto è in fase di creazione',

        translation.newProjectTitle: 'Nuovo progetto',
        translation.newProjectNotLoggedWarning:
            'I progetti non verranno salvati se non hai effettuato l\'accesso con Google',
        translation.newProjectNameLabel: 'Nome del progetto',
        translation.newProjectMediaTitle: 'Media:',
        translation.newProjectNoMediaSubtitle: 'Seleziona media dalla fotocamera o dalla galleria',
        translation.newProjectPhotoDurationTitle: 'Durata della foto:',
        translation.newProjectMediaTypeTitle: 'Tipo di media',
        translation.newProjectMediaTypeImage: 'Immagine',
        translation.newProjectMediaTypeVideo: 'Video',
        translation.newProjectPickMediaCamera: 'Scegli media dalla fotocamera',
        translation.newProjectPickMediaGallery: 'Scegli media dalla galleria',
        translation.newProjectChangeMedia: 'Cambia media:',

        // Editor page keys
        translation.addTextDialogTitle: 'Aggiungi nuovo testo',
        translation.addTextDialogMessage: 'Il testo verrà aggiunto nella posizione attuale del video',
        translation.addTextDialogLabel: 'Testo da aggiungere',
        translation.addTextDialogDuration: 'Durata del testo',
        translation.addTextDialogCancel: 'Annulla',
        translation.addTextDialogSave: 'Salva',
        translation.editTextDialogTitle: 'Modifica testo',
        translation.editTextDialogLabel: 'Testo modificato',
        translation.fontColorDialogTitle: 'Colore del carattere',
        translation.backgroundColorDialogTitle: 'Colore di sfondo',
        translation.backgroundColorDialogClear: 'Nessuno',
        translation.fontSizeDialogTitle: 'Imposta dimensione carattere',
        translation.fontSizeDialogSubtitle: 'Dimensione carattere',
        translation.selectTextDialogTitle: 'Seleziona il testo da modificare',
        translation.setStartDialogTitle: 'Regola durata',
        translation.setStartDialogSubtitle:
            'La durata del testo supera la lunghezza del video. Vuoi regolarne la durata?',
        translation.setStartDialogCancel: 'Annulla',
        translation.setStartDialogAdjust: 'Regola',
        translation.setTextDurationTitle: 'Imposta durata del testo',
        translation.setTextPositionTitle: 'Imposta posizione del testo',
        translation.setTrackVolumeTitle: 'Imposta volume traccia',
        translation.setTrackVolumeMasterLabel: 'Volume\nprincipale',
        translation.setTrackVolumeAudioLabel: 'Volume\naudio',
        translation.audioTimelineAddAudio: 'Aggiungi audio!',
        translation.textTimelineAddText: 'Aggiungi testo!',
        translation.audioStartSheetTitle: 'Inizio audio',
        translation.exportSheetFPSTitle: 'FPS',
        translation.exportSheetFPSSubtitle: 'Fotogrammi al secondo',
        translation.exportSheetBitrateTitle: 'Bitrate',
        translation.exportSheetBitrateSubtitle: 'Qualità video',
        translation.exportSheetButtonText: 'Esporta',

        // -- Editor options
        translation.baseVideoTrimTitle: 'Taglia',
        translation.baseVideoAudioTitle: 'Audio',
        translation.baseVideoTextTitle: 'Testo',
        translation.baseVideoCropTitle: 'Taglia',
        translation.trimOptionsTrimStart: 'Inizio\ntaglio',
        translation.trimOptionsTrimEnd: 'Fine\ntaglio',
        translation.trimOptionsJumpBack: 'Indietro',
        translation.trimOptionsJumpForward: 'Avanti',
        translation.audioOptionsAddAudio: 'Aggiungi\naudio',
        translation.audioOptionsChangeAudio: 'Cambia\naudio',
        translation.audioOptionsRemoveAudio: 'Rimuovi\naudio',
        translation.audioOptionsTrackVolume: 'Volume\ndella traccia',
        translation.audioOptionsAudioStart: 'Inizio\naudio',
        translation.audioOptionsAudioStartErrorTitle: 'Impossibile impostare l\'inizio dell\'audio',
        translation.audioOptionsAudioStartErrorSubtitleNoAudio: 'Nessun audio è stato aggiunto al video',
        translation.audioOptionsAudioStartErrorSubtitleSmallerDuration:
            'La durata dell\'audio è inferiore alla durata del video',
        translation.textOptionsAddText: 'Aggiungi\ntesto',
        translation.textOptionsNoSelectedTextErrorTitle: 'Nessun testo selezionato',
        translation.textOptionsEditText: 'Modifica\ntesto',
        translation.textOptionsEditTextError: 'Seleziona un testo per modificare il suo contenuto.',
        translation.textOptionsFontSize: 'Dimensione\ncarattere',
        translation.textOptionsFontSizeError: 'Seleziona un testo per cambiare la dimensione del carattere.',
        translation.textOptionsFontColor: 'Colore\ncarattere',
        translation.textOptionsFontColorError: 'Seleziona un testo per cambiare il colore del carattere.',
        translation.textOptionsBackgroundColor: 'Colore\ndi sfondo',
        translation.textOptionsBackgroundColorError: 'Seleziona un testo per cambiare il colore di sfondo.',
        translation.textOptionsTextPosition: 'Posizione\ndel testo',
        translation.textOptionsTextPositionError: 'Seleziona un testo per cambiare la posizione.',
        translation.textOptionsTextDuration: 'Durata\ndel testo',
        translation.textOptionsTextDurationError: 'Seleziona un testo per impostare la durata.',
        translation.textOptionsTextStart: 'Inizio\ntesto',
        translation.textOptionsTextStartTooCloseTitleError: 'Testo troppo vicino alla fine',
        translation.textOptionsTextStartTooCloseSubtitleError:
            'Impossibile impostare l\'inizio del testo a 100 ms o meno dalla fine del video.',
        translation.textOptionsTextStartError: 'Seleziona un testo per impostare l\'inizio.',
        translation.textOptionsDeleteText: 'Elimina\ntesto',
        translation.cropOptionsFreeForm: 'Forma\nlibera',
        translation.cropOptionsCrop: 'Proporzione',
        translation.cropOptionsReset: 'Ripristina\ntaglio',

        // Export page keys
        translation.exportPageLoadingTitle: 'Esportazione del video',
        translation.exportPageLoadingSubtitle:
            'Non chiudere l\'applicazione finché il video non sarà completamente esportato',
        translation.exportPageSuccessTitle: 'Il video è stato esportato correttamente',
        translation.exportPageShareMessage: 'Condividi il video su',
        translation.exportPageGoHome: 'Torna ai miei progetti',
        translation.exportPageOtherOptions: 'Altri',
        translation.exportPageErrorTitle: 'Ops!\nQualcosa è andato storto!',
        translation.exportPageErrorSubtitle: 'Si è verificato un errore durante l\'esportazione del video. Riprova.',
        translation.exportPageErrorLogsTitle: 'Log degli errori',
        translation.exportPageErrorCommandTitle: 'Comando eseguito',

        // Settings page keys
        translation.settingsPageTitle: 'Impostazioni',
        translation.settingsPageLanguageTitle: 'Seleziona lingua',
        translation.settingsPageThemeTitle: 'Tema',
        translation.settingsPageThemeButton: 'Cambia tema',
        translation.settingsEnglish: 'Inglese',
        translation.settingsSpanish: 'Spagnolo',
        translation.settingsItalian: 'Italiano',

        // Controller keys
        // -- Editor
        translation.deniedOperationErrorTitle: 'Operazione negata',
        translation.setTrimStartErrorMessage: 'Impossibile impostare l\'inizio del taglio dopo la fine del taglio',
        translation.setTrimEndErrorMessage: 'Impossibile impostare la fine del taglio prima dell\'inizio del taglio',
        translation.noAudioToRemoveErrorMessage: 'Nessun audio da rimuovere',
        translation.cannotDeleteTextErrorTitle: 'Impossibile eliminare il testo',
        translation.cannotDeleteTextErrorMessage: 'Nessun testo è stato selezionato. Seleziona un testo da eliminare.',

        // -- Export
        translation.shareYourVideoMessage: 'Condividi il tuo video!',

        // -- New project
        translation.errorAddingProjectTitle: 'Errore durante l\'aggiunta del progetto',
        translation.errorAddingProjectMessage: 'Si è verificato un errore durante l\'aggiunta del progetto. Riprova.',

        // -- Projects
        translation.projectCreatedSuccessTitle: 'Progetto creato!',
        translation.projectCreatedLocalSuccessMessage: 'Il tuo progetto è stato creato correttamente',
        translation.projectCreatedAndSavedToCloudSuccessMessage:
            'Il tuo progetto è stato creato e salvato nel cloud con successo',
        translation.projectSavedToCloudSuccessTitle: 'Progetto salvato!',
        translation.projectSavedToCloudSuccessMessage: 'Il tuo progetto è stato salvato nel cloud con successo',
        translation.projectSignInToSaveTitle: 'Effettua l\'accesso per salvare il tuo progetto',
        translation.projectSignInToSaveMessage: 'Devi effettuare l\'accesso per salvare il tuo progetto nel cloud',
      };
}
