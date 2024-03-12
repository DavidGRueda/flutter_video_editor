import '../translation_keys.dart' as translation;

class Es {
  Map<String, String> get messages => {
        translation.projectLastEdited: 'Última edición: ',
        translation.deleteDialogTitle: '¿Eliminar proyecto?',
        translation.deleteDialogMessage:
            'Esta acción no se puede deshacer. ¿Estás seguro de que quieres eliminar el proyecto?',
        translation.deleteDialogCancel: 'Cancelar',
        translation.deleteDialogDelete: 'Eliminar',
        translation.editDialogTitle: 'Editar proyecto',
        translation.editDialogLabelText: 'Nombre del proyecto',
        translation.editDialogCancel: 'Cancelar',
        translation.editDialogSave: 'Guardar',

        translation.homePageTitle: 'Mis proyectos',
        translation.homePageTabTitle: 'Projectos recientes',
        translation.homePageTitleNoProjects: '¡Crea nuevos proyectos!',
        translation.homePageSubtitleNoProjects: "Puedes crear nuevos proyectos haciendo clic en el botón '+' debajo.",
        translation.homePageLoadingProjects: 'Cargando proyectos...',
        translation.homePageLogInButton: 'Log in',
        translation.homePageLogoutSubtitle: 'Has iniciado sesión como',
        translation.homepageLogoutSnackbarTitle: 'Cerrando sesión',
        translation.homepageLogoutSnackbarMessage: 'Has cerrado sesión en tu cuenta de Google',
        translation.homePageLogoutButtonText: 'Cerrar sesión',

        // New project page keys
        translation.newProjectFooterCancel: 'Cancelar',
        translation.newProjectFooterStartEditing: 'Crear proyecto',
        translation.newProjectSnackbarTitle: 'Creando proyecto...',
        translation.newProjectSnackbarMessage: 'Tu proyecto se está creando',

        translation.newProjectTitle: 'Nuevo proyecto',
        translation.newProjectNotLoggedWarning: "Los proyectos no se guardarán si no has iniciado sesión con Google",
        translation.newProjectNameLabel: 'Nombre del proyecto',
        translation.newProjectMediaTitle: 'Multimedia:',
        translation.newProjectNoMediaSubtitle: 'Selecciona multimedia de la cámara o la galería',
        translation.newProjectPhotoDurationTitle: 'Duración de la foto:',
        translation.newProjectMediaTypeTitle: 'Tipo de multimedia',
        translation.newProjectMediaTypeImage: 'Imagen',
        translation.newProjectMediaTypeVideo: 'Video',
        translation.newProjectPickMediaCamera: 'Seleccionar multimedia desde cámara',
        translation.newProjectPickMediaGallery: 'Seleccionar multimedia desde galería',
        translation.newProjectChangeMedia: 'Cambiar multimedia:',

        // Editor page keys
        translation.addTextDialogTitle: 'Agregar nuevo texto',
        translation.addTextDialogMessage: 'El texto se agregará en la posición actual del video',
        translation.addTextDialogLabel: 'Texto a agregar',
        translation.addTextDialogDuration: 'Duración del texto',
        translation.addTextDialogCancel: 'Cancelar',
        translation.addTextDialogSave: 'Guardar',
        translation.editTextDialogTitle: 'Editar texto',
        translation.editTextDialogLabel: 'Texto editado',
        translation.fontColorDialogTitle: 'Color de fuente',
        translation.backgroundColorDialogTitle: 'Color de fondo',
        translation.backgroundColorDialogClear: 'Ninguno',
        translation.fontSizeDialogTitle: 'Establecer tamaño de fuente',
        translation.fontSizeDialogSubtitle: 'Tamaño de fuente',
        translation.selectTextDialogTitle: 'Seleccionar el texto para editar',
        translation.setStartDialogTitle: 'Ajustar duración',
        translation.setStartDialogSubtitle:
            'La duración del texto supera la longitud del vídeo. ¿Quieres ajustar la duración?',
        translation.setStartDialogCancel: 'Cancelar',
        translation.setStartDialogAdjust: 'Ajustar',
        translation.setTextDurationTitle: 'Establecer duración del texto',
        translation.setTextPositionTitle: 'Establecer posición del texto',
        translation.setTrackVolumeTitle: 'Establecer volumen de la pista',
        translation.setTrackVolumeMasterLabel: 'Volumen\nmaestro',
        translation.setTrackVolumeAudioLabel: 'Volumen\nde audio',
        translation.audioTimelineAddAudio: '¡Agregar audio!',
        translation.textTimelineAddText: '¡Agregar texto!',
        translation.audioStartSheetTitle: 'Inicio de audio',
        translation.exportSheetFPSTitle: 'FPS',
        translation.exportSheetFPSSubtitle: 'Fotogramas por segundo',
        translation.exportSheetBitrateTitle: 'Bitrate',
        translation.exportSheetBitrateSubtitle: 'Calidad de video',
        translation.exportSheetButtonText: 'Exportar',

        // -- Editor options
        translation.baseVideoTrimTitle: 'Recortar',
        translation.baseVideoAudioTitle: 'Audio',
        translation.baseVideoTextTitle: 'Texto',
        translation.baseVideoCropTitle: 'Tamaño',
        translation.trimOptionsTrimStart: 'Inicio\nde recorte',
        translation.trimOptionsTrimEnd: 'Final\nde recorte',
        translation.trimOptionsJumpBack: 'Retroceder',
        translation.trimOptionsJumpForward: 'Avanzar',
        translation.audioOptionsAddAudio: 'Agregar\naudio',
        translation.audioOptionsChangeAudio: 'Cambiar\naudio',
        translation.audioOptionsRemoveAudio: 'Eliminar\naudio',
        translation.audioOptionsTrackVolume: 'Volumen\nde pistas',
        translation.audioOptionsAudioStart: 'Inicio\nde audio',
        translation.audioOptionsAudioStartErrorTitle: 'No se puede establecer el inicio del audio',
        translation.audioOptionsAudioStartErrorSubtitleNoAudio: 'No se ha agregado audio al video',
        translation.audioOptionsAudioStartErrorSubtitleSmallerDuration:
            'La duración del audio es menor que la duración del video',
        translation.textOptionsAddText: 'Agregar\ntexto',
        translation.textOptionsNoSelectedTextErrorTitle: 'Ningún texto seleccionado',
        translation.textOptionsEditText: 'Editar\ntexto',
        translation.textOptionsEditTextError: 'Selecciona un texto para editar su contenido.',
        translation.textOptionsFontSize: 'Tamaño de\nfuente',
        translation.textOptionsFontSizeError: 'Selecciona un texto para cambiar el tamaño de fuente.',
        translation.textOptionsFontColor: 'Color de\nfuente',
        translation.textOptionsFontColorError: 'Selecciona un texto para cambiar el color de fuente.',
        translation.textOptionsBackgroundColor: 'Color de\nfondo',
        translation.textOptionsBackgroundColorError: 'Selecciona un texto para cambiar el color de fondo.',
        translation.textOptionsTextPosition: 'Posición\ndel texto',
        translation.textOptionsTextPositionError: 'Selecciona un texto para cambiar la posición.',
        translation.textOptionsTextDuration: 'Duración\ndel texto',
        translation.textOptionsTextDurationError: 'Selecciona un texto para establecer la duración.',
        translation.textOptionsTextStart: 'Inicio de\ntexto',
        translation.textOptionsTextStartTooCloseTitleError: 'Texto demasiado cerca del final',
        translation.textOptionsTextStartTooCloseSubtitleError:
            'No se puede establecer el inicio del texto 100 ms o menos del final del video.',
        translation.textOptionsTextStartError: 'Selecciona un texto para establecer el inicio.',
        translation.textOptionsDeleteText: 'Eliminar\ntexto',
        translation.cropOptionsFreeForm: 'Forma\nlibre',
        translation.cropOptionsCrop: 'ratio',
        translation.cropOptionsReset: 'Restablecer\nrecorte',

        // Export page keys
        translation.exportPageLoadingTitle: 'Exportando el video',
        translation.exportPageLoadingSubtitle:
            'Por favor, no cierres la aplicación hasta que el video se exporte completamente',
        translation.exportPageSuccessTitle: 'El video se exportó correctamente',
        translation.exportPageShareMessage: 'Comparte el video en',
        translation.exportPageGoHome: 'Volver a mis proyectos',
        translation.exportPageOtherOptions: 'Otros',
        translation.exportPageErrorTitle: '¡Oops!\n¡Algo salió mal!',
        translation.exportPageErrorSubtitle: 'Hubo un error al exportar el video. Por favor, inténtalo de nuevo.',
        translation.exportPageErrorLogsTitle: 'Registros de errores',
        translation.exportPageErrorCommandTitle: 'Comando ejecutado',

        // Settings page keys
        translation.settingsPageTitle: 'Ajustes',
        translation.settingsPageLanguageTitle: 'Seleccionar idioma',
        translation.settingsPageThemeTitle: 'Tema',
        translation.settingsPageThemeButton: 'Cambiar tema',
        translation.settingsEnglish: 'Inglés',
        translation.settingsSpanish: 'Español',

        // Controller keys
        // -- Editor
        translation.deniedOperationErrorTitle: "Operación denegada",
        translation.setTrimStartErrorMessage:
            'No se puede establecer el inicio del recorte después del final del recorte',
        translation.setTrimEndErrorMessage: 'No se puede establecer el final del recorte antes del inicio del recorte',
        translation.noAudioToRemoveErrorMessage: 'No hay audio para eliminar',
        translation.cannotDeleteTextErrorTitle: 'No se puede eliminar el texto',
        translation.cannotDeleteTextErrorMessage:
            'No se ha seleccionado ningún texto. Selecciona un texto para eliminarlo.',

        // -- Export
        translation.shareYourVideoMessage: '¡Comparte tu video!',

        // -- New project
        translation.errorAddingProjectTitle: 'Error al agregar el proyecto',
        translation.errorAddingProjectMessage: 'Hubo un error al agregar el proyecto. Por favor, inténtalo de nuevo.',

        // -- Projects
        translation.projectCreatedSuccessTitle: '¡Proyecto creado!',
        translation.projectCreatedLocalSuccessMessage: 'Tu proyecto se creó correctamente',
        translation.projectCreatedAndSavedToCloudSuccessMessage:
            'Tu proyecto se creó y guardó en la nube correctamente',
        translation.projectSavedToCloudSuccessTitle: '¡Proyecto guardado!',
        translation.projectSavedToCloudSuccessMessage: 'Tu proyecto se guardó en la nube correctamente',
        translation.projectSignInToSaveTitle: 'Inicia sesión para guardar tu proyecto',
        translation.projectSignInToSaveMessage: 'Necesitas iniciar sesión para guardar tu proyecto en la nube',
      };
}
