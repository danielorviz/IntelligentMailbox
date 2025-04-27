// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Aplicación';

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String hello(String userName) {
    return 'Hola $userName';
  }

  @override
  String get home => 'Inicio';

  @override
  String get packages => 'Paquetes';

  @override
  String get keys => 'Claves';

  @override
  String get mail => 'Correo';

  @override
  String get delete => 'Eliminar';

  @override
  String get noMailboxSelected => 'No hay un buzón seleccionado';

  @override
  String get confirmDeleteAuthKey => '¿Seguro que desea eliminar la clave autorizada?';

  @override
  String get authKeyDeleted => 'Clave autorizada eliminada';

  @override
  String get permanentKey => 'Acceso permanente';

  @override
  String get mustSelectStartDate => 'Debes seleccionar una fecha de inicio primero';

  @override
  String get endDateAfterStartDate => 'La fecha de finalización debe ser posterior a la fecha de inicio';

  @override
  String get endDateAndStartDateMandatory => 'Las fechas de inicio y finalización son obligatorias';

  @override
  String get successfullyUpdated => 'Actualizado con éxito';

  @override
  String get editKey => 'Editar clave';

  @override
  String get newKey => 'Nueva clave';

  @override
  String get keyName => 'Nombre de la clave';

  @override
  String get enterName => 'Por favor, introduzca un nombre';

  @override
  String get password => 'Contraseña';

  @override
  String get enterValue => 'Por favor, introduzca un valor';

  @override
  String get startDate => 'Fecha de inicio';

  @override
  String get endDate => 'Fecha de finalización';

  @override
  String get date => 'Fecha';

  @override
  String get selectDate => 'Seleccione una fecha';

  @override
  String get save => 'Guardar';

  @override
  String get haveNoAuthKeys => 'No tiene claves autorizadas';

  @override
  String get haveNoPackages => 'No tiene códigos autorizados';

  @override
  String get confirmDeleteAuthPackage => '¿Estás seguro de que deseas eliminar este código autorizado?';

  @override
  String get authPackageDeleted => 'Paquete código eliminado';

  @override
  String get editPackage => 'Editar código';

  @override
  String get newPackage => 'Nuevo código';

  @override
  String get packageName => 'Nombre';

  @override
  String get packageCode => 'Código';

  @override
  String get enterPackageCode => 'Por favor, introduzca un código';

  @override
  String get permanentAccess => 'Acceso permanente';

  @override
  String get received => 'Recibido';

  @override
  String get packageAlreadyReceived => 'El paquete ya ha sido recibido';

  @override
  String get pending => 'Pendiente recepción';

  @override
  String get status => 'Estado: ';

  @override
  String get confirm => 'Confirmar';

  @override
  String get wifiDisabled => 'Wi-Fi Desactivado';

  @override
  String get wifiDisabledMessage => 'El Wi-Fi está desactivado. Por favor, actívelo para continuar.';

  @override
  String get connectionError => 'Error de Conexión';

  @override
  String get arduinoAPConnectionError => 'No se pudo conectar al punto de acceso del Arduino. Por favor, verifique de nuevo la conexión y vuelva a intentarlo.';

  @override
  String get incorrectCredentials => 'Correo electrónico o contraseña incorrectos.';

  @override
  String get accountVerificationError => 'Error al verificar la cuenta.';

  @override
  String get mailboxNotFound => 'Buzón no encontrado. Por favor, verifique el ID y la clave.';

  @override
  String get informationVerificationError => 'Error al verificar la información.';

  @override
  String get mailboxConnectionError => 'Error al conectar con el buzón';

  @override
  String get wifiCredentialsError => 'Credenciales Wi-Fi incorrectas';

  @override
  String get mailboxConnectedWiFi => 'Buzón conectado a la red Wi-Fi';

  @override
  String get verify => 'Verificar';

  @override
  String get connect => 'Conectar';

  @override
  String get send => 'Enviar';

  @override
  String get finish => 'Finalizar';

  @override
  String get connectNewMailbox => 'Conectar nuevo buzón';

  @override
  String get cancel => 'Cancelar';

  @override
  String get verifyYourAccount => 'Verifique su cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get mailboxDetails => 'Datos del buzón';

  @override
  String get enterMailboxDetails => 'Ingrese los datos del buzón';

  @override
  String get mailboxId => 'ID del buzón';

  @override
  String get mailboxKey => 'Clave del buzón';

  @override
  String get connectToMailbox => 'Conectar al buzón';

  @override
  String get pleaseConnectManually => 'Por favor, para continuar, conéctese manualmente a la red Wi-Fi del buzón:';

  @override
  String get passwordCopied => 'Contraseña copiada al portapapeles';

  @override
  String get connectMailboxToWiFi => 'Conectar buzón a la red Wi-Fi';

  @override
  String get selectWiFiNetwork => 'Seleccione la red Wi-Fi a la que conectará su buzón';

  @override
  String get scanNetworks => 'Escanear redes';

  @override
  String get finishSetup => 'Finalizar configuración';

  @override
  String get congratulationsSetupCompleted => '¡Enhorabuena! Ha finalizado la configuración del buzón.';

  @override
  String get connectTo => 'Conectar a';

  @override
  String get manageSmartMailboxes => 'Gestione sus buzones inteligentes de manera eficiente y segura con nuestra aplicación.';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get copyright => '© 2025 Intelligent Mailbox. Todos los derechos reservados.';

  @override
  String get passwordCannotBeEmpty => 'La contraseña no puede estar vacía';

  @override
  String get enterValidEmail => 'Ingrese un correo electrónico válido';

  @override
  String get emailCannotBeEmpty => 'El correo electrónico no puede estar vacío';

  @override
  String get loginError => 'Error al iniciar sesión';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get signup => 'Registrarse';

  @override
  String get signout => 'Cerrar sesión';

  @override
  String get signOutConfirm => '¿Desea cerrar sesión?';

  @override
  String get signupSuccess => 'Cuenta creada con éxito. Por favor, inicie sesión.';

  @override
  String get signupError => 'Error al crear la cuenta. Por favor, inténtelo de nuevo.';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get alreadyHaveAccount => '¿Ya tiene una cuenta?';

  @override
  String get name => 'Nombre';

  @override
  String get nameCannotBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado. Inténtalo de nuevo.';

  @override
  String get userNotFound => 'No se encontró un usuario con este correo electrónico.';

  @override
  String get emailAlreadyInUse => 'El correo electrónico ya está en uso.';

  @override
  String get invalidEmail => 'El correo electrónico no es válido.';

  @override
  String get weakPassword => 'La contraseña es demasiado débil.';

  @override
  String get emailNotVerified => 'Por favor, verifica tu correo electrónico antes de continuar.';

  @override
  String get forgotPassword => '¿Olvidó su contraseña?';

  @override
  String get passwordResetEmailSent => 'Le hemos enviado un correo para restablecer su contraseña.';

  @override
  String get passwordResetError => 'Ocurrió un error al intentar enviar el correo de recuperación.';

  @override
  String get passwordReset => 'Restablecer la contraseña';

  @override
  String get passwordResetWillSent => 'Se le enviará un correo para restablecer su contraseña a';

  @override
  String get enterEmailToResetPassword => 'Ingrese un correo electrónico para restablecer la contraseña';

  @override
  String get info => 'Info.';

  @override
  String get mailboxConfig => 'Configuración del buzón';

  @override
  String get checkConnection => 'Comprobar conexión';

  @override
  String get mailboxStatus => 'Estado del buzón';

  @override
  String get checkingConnection => 'Comprobando conexión ...';

  @override
  String get checking => 'Comprobando ...';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get lastCheck => 'Comprobado: ';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get active => 'Activadas';

  @override
  String get inactive => 'Desactivadas';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get lastKeyboardAccess => 'Último acceso por teclado';

  @override
  String get lastScanAccess => 'Último acceso por escaneo';

  @override
  String get lastNotificationReceived => 'Última notificación recibida';

  @override
  String get noRecentInfo => 'Sin información reciente';

  @override
  String get mailboxes => 'Buzones';

  @override
  String get nfcError => 'Error escaneando';

  @override
  String get nfcNotDetected => 'No se ha detectado ninguna etiqueta NFC';

  @override
  String get scanNfc => 'Escanear NFC';

  @override
  String get scanning => 'Escaneando ...';

  @override
  String get nfcNotAvailable => 'NFC no está activo';

  @override
  String get door => 'Puerta';

  @override
  String get openDoor => 'Abrir puerta';

  @override
  String get opened => 'Abierta';

  @override
  String get closed => 'Cerrada';

  @override
  String get instructionSent => 'Instrucción enviada';

  @override
  String get confirmOpenDoor => '¿Seguro que quiere abrir la puerta?';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mié';

  @override
  String get thursday => 'Jue';

  @override
  String get friday => 'Vie';

  @override
  String get saturday => 'Sáb';

  @override
  String get sunday => 'Dom';

  @override
  String get selectMonth => 'Seleccionar mes';

  @override
  String get selectYear => 'Seleccionar año';

  @override
  String get notificationsStatistics => 'Estadísticas de Notificaciones';

  @override
  String notificationTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'packageNotRecognize': 'Paquete no reconocido',
        'packageRecived': 'Paquete autorizado recibido',
        'keyNFCAccess': 'Acceso por llave NFC',
        'newLetter': 'Nueva carta recibida',
        'mailboxFull': 'Buzón lleno',
        'mailboxOpened': 'Apertura del buzón',
        'mailboxOpenFailed': 'Intento apertura buzón fallido',
        'mailboxConnected': 'Buzón conectado',
        'doorOpened': 'La puerta está abierta',
        'other': 'Notification',
      },
    );
    return '$_temp0';
  }

  @override
  String notificationMessage(String message) {
    String _temp0 = intl.Intl.selectLogic(
      message,
      {
        'packageNotRecognizeMessage': 'Se ha intentado abrir la puerta',
        'packageRecivedMessage': 'Puerta abierta con el paquete',
        'keyNFCAccessMessage': 'Puerta abierta con llave NFC',
        'newLetterMessage': 'Ha recibido un nuevo correo',
        'mailboxFullMessage': 'Es posible que el buzón esté lleno o se haya atascado un correo',
        'mailboxOpenedMessage': 'Puerta abierta con la clave',
        'mailboxOpenFailedMessage': 'Se ha intentado abrir la puerta',
        'mailboxConnectedMessage': 'Buzón conectado a red wifi',
        'doorOpened': 'La puerta está abierta',
        'other': 'Notification',
      },
    );
    return '$_temp0';
  }

  @override
  String language(String lang) {
    String _temp0 = intl.Intl.selectLogic(
      lang,
      {
        'es': 'Español',
        'en': 'Inglés',
        'other': 'Inglés',
      },
    );
    return '$_temp0';
  }

  @override
  String get mailboxSettingsTitle => 'Configuración del buzón';

  @override
  String get mailboxNameLabel => 'Nombre del buzón';

  @override
  String get mailboxNameHint => 'Por favor ingresa un nombre';

  @override
  String get notificationsEnabledLabel => 'Notificaciones activadas';

  @override
  String get notificationLanguageLabel => 'Idioma de notificaciones';

  @override
  String get saveSettingsButton => 'Guardar configuración';

  @override
  String get settingsSavedSuccess => 'Configuración guardada';

  @override
  String get settingsSavedError => 'Error al guardar la configuración';
}
