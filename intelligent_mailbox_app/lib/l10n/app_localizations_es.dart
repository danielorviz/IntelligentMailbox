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
  String get permanentKey => 'Clave permanente';

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
  String get selectDate => 'Seleccione una fecha';

  @override
  String get save => 'Guardar';

  @override
  String get haveNoAuthKeys => 'No tiene claves autorizadas';

  @override
  String get haveNoPackages => 'No tiene paquetes autorizados';

  @override
  String get confirmDeleteAuthPackage => '¿Estás seguro de que deseas eliminar este paquete autorizado?';

  @override
  String get authPackageDeleted => 'Paquete autorizado eliminado';

  @override
  String get editPackage => 'Editar paquete';

  @override
  String get newPackage => 'Nuevo paquete';

  @override
  String get packageCode => 'Código del paquete';

  @override
  String get enterPackageCode => 'Por favor, introduzca un código de paquete';

  @override
  String get permanentAccess => 'Acceso permanente';

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
}
