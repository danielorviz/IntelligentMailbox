// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Intelligent Mailbox';

  @override
  String get helloWorld => 'Hello, World!';

  @override
  String hello(String userName) {
    return 'Hello $userName';
  }

  @override
  String get home => 'Home';

  @override
  String get packages => 'Packages';

  @override
  String get keys => 'Keys';

  @override
  String get mail => 'Mail';

  @override
  String get delete => 'Delete';

  @override
  String get noMailboxSelected => 'No mailbox selected';

  @override
  String get confirmDeleteAuthKey => 'Are you sure you want to delete this authorized key?';

  @override
  String get authKeyDeleted => 'Authorized key removed';

  @override
  String get permanentKey => 'Permanent access';

  @override
  String get mustSelectStartDate => 'You must select a start date first';

  @override
  String get endDateAfterStartDate => 'The end date must be after the start date';

  @override
  String get endDateAndStartDateMandatory => 'Start and end dates are mandatory';

  @override
  String get successfullyUpdated => 'Successfully updated';

  @override
  String get editKey => 'Edit key';

  @override
  String get newKey => 'New key';

  @override
  String get keyName => 'Key name';

  @override
  String get enterName => 'Please enter a name';

  @override
  String get password => 'password';

  @override
  String get enterValue => 'Please enter a value';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get date => 'Date';

  @override
  String get selectDate => 'Select a date';

  @override
  String get save => 'Save';

  @override
  String get haveNoAuthKeys => 'You have no authorized keys';

  @override
  String get haveNoPackages => 'Has no authorized code';

  @override
  String get confirmDeleteAuthPackage => 'Are you sure you want to delete this authorized code?';

  @override
  String get authPackageDeleted => 'Authorized code removed';

  @override
  String get editPackage => 'Edit code';

  @override
  String get newPackage => 'New code';

  @override
  String get packageName => 'Name';

  @override
  String get packageCode => 'Code';

  @override
  String get enterPackageCode => 'Please enter a code code';

  @override
  String get permanentAccess => 'Permanent access';

  @override
  String get received => 'Received';

  @override
  String get packageAlreadyReceived => 'The package has already been received';

  @override
  String get pending => 'Pending reception';

  @override
  String get status => 'Status: ';

  @override
  String get confirm => 'Confirm';

  @override
  String get wifiDisabled => 'Wi-Fi Disabled';

  @override
  String get wifiDisabledMessage => 'Wi-Fi is disabled. Please enable it to continue.';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get arduinoAPConnectionError => 'Could not connect to the Arduino access point. Please check the connection and try again.';

  @override
  String get incorrectCredentials => 'Incorrect email or password.';

  @override
  String get accountVerificationError => 'Account verification failed.';

  @override
  String get mailboxNotFound => 'Mailbox not found. Please check the ID and key.';

  @override
  String get informationVerificationError => 'Error verifying information.';

  @override
  String get mailboxConnectionError => 'Error connecting to the mailbox';

  @override
  String get wifiCredentialsError => 'Incorrect Wi-Fi credentials';

  @override
  String get mailboxConnectedWiFi => 'Mailbox connected to the Wi-Fi network';

  @override
  String get verify => 'Verify';

  @override
  String get connect => 'Connect';

  @override
  String get send => 'Send';

  @override
  String get finish => 'Finish';

  @override
  String get connectNewMailbox => 'Connect new mailbox';

  @override
  String get cancel => 'Cancel';

  @override
  String get verifyYourAccount => 'Verify your account';

  @override
  String get email => 'Email';

  @override
  String get mailboxDetails => 'Mailbox details';

  @override
  String get enterMailboxDetails => 'Enter mailbox details';

  @override
  String get mailboxId => 'Mailbox ID';

  @override
  String get mailboxKey => 'Mailbox key';

  @override
  String get connectToMailbox => 'Connect to mailbox';

  @override
  String get pleaseConnectManually => 'Please, to continue, manually connect to the mailbox Wi-Fi network:';

  @override
  String get passwordCopied => 'Password copied to clipboard';

  @override
  String get connectMailboxToWiFi => 'Connect mailbox to the Wi-Fi network';

  @override
  String get selectWiFiNetwork => 'Select the Wi-Fi network to which you will connect your mailbox';

  @override
  String get scanNetworks => 'Scan networks';

  @override
  String get finishSetup => 'Finish setup';

  @override
  String get congratulationsSetupCompleted => 'Congratulations! You have completed the mailbox setup.';

  @override
  String get connectTo => 'Connect to';

  @override
  String get manageSmartMailboxes => 'Manage your smart mailboxes efficiently and securely with our app.';

  @override
  String get login => 'Login';

  @override
  String get copyright => '© 2025 Intelligent Mailbox. All rights reserved.';

  @override
  String get passwordCannotBeEmpty => 'The password cannot be empty';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get emailCannotBeEmpty => 'The email cannot be empty';

  @override
  String get loginError => 'Error logging in';

  @override
  String get welcome => 'Welcome';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signup => 'Sign Up';

  @override
  String get signout => 'Sign Out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get signupSuccess => 'Account created successfully. Please log in.';

  @override
  String get signupError => 'Error creating account. Please try again.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters long';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get name => 'Name';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get unexpectedError => 'An unexpected error occurred. Please try again.';

  @override
  String get userNotFound => 'No user found with this email address.';

  @override
  String get emailAlreadyInUse => 'The email address is already in use.';

  @override
  String get invalidEmail => 'The email address is invalid.';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get emailNotVerified => 'Por favor, verifica tu correo electrónico antes de continuar.';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get passwordResetEmailSent => 'Te hemos enviado un correo para restablecer tu contraseña.';

  @override
  String get passwordResetError => 'Ocurrió un error al intentar enviar el correo de recuperación.';

  @override
  String get passwordReset => 'Password Reset';

  @override
  String get passwordResetWillSent => 'A password reset email will be sent to';

  @override
  String get enterEmailToResetPassword => 'Enter an email to reset the password';

  @override
  String get info => 'Info.';

  @override
  String get mailboxConfig => 'Mailbox configuration';

  @override
  String get checkConnection => 'Check connection';

  @override
  String get mailboxStatus => 'Mailbox status';

  @override
  String get checkingConnection => 'Checking connection ...';

  @override
  String get checking => 'Checking ...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get lastCheck => 'Checked: ';

  @override
  String get notifications => 'Notifications';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get timezone => 'Timezone';

  @override
  String get lastKeyboardAccess => 'Last keyboard access';

  @override
  String get lastScanAccess => 'Last scan access';

  @override
  String get lastNotificationReceived => 'Last notification received';

  @override
  String get noRecentInfo => 'No recent information';

  @override
  String get mailboxes => 'Mailboxes';

  @override
  String get nfcError => 'Error scaning';

  @override
  String get nfcNotDetected => 'No NFC tag detected';

  @override
  String get scanNfc => 'Scan NFC';

  @override
  String get scanning => 'Scanning ...';

  @override
  String get nfcNotAvailable => 'NFC not available';

  @override
  String get door => 'Door';

  @override
  String get openDoor => 'Open door';

  @override
  String get opened => 'Opened';

  @override
  String get closed => 'closed';

  @override
  String get instructionSent => 'Instruction sent';

  @override
  String get confirmOpenDoor => 'Are you sure you want to open the door?';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get selectYear => 'Select Year';

  @override
  String get notificationsStatistics => 'Notifications Statistics';

  @override
  String notificationTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'packageNotRecognize': 'Package not recognized',
        'packageRecived': 'Authorized package received',
        'keyNFCAccess': 'NFC key access',
        'newLetter': 'New letter received',
        'mailboxFull': 'Mailbox full',
        'mailboxOpened': 'Mailbox opened',
        'mailboxOpenFailed': 'Mailbox opening attempt failed',
        'mailboxConnected': 'Mailbox connected',
        'doorOpened': 'The door is open',
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
        'packageNotRecognizeMessage': 'An attempt was made to open the door',
        'packageRecivedMessage': 'Door opened with the package',
        'keyNFCAccessMessage': 'Door opened with NFC key',
        'newLetterMessage': 'You have received new mail',
        'mailboxFullMessage': 'The mailbox might be full or mail has gotten stuck',
        'mailboxOpenedMessage': 'Door opened with the key',
        'mailboxOpenFailedMessage': 'An attempt was made to open the door',
        'mailboxConnectedMessage': 'Mailbox connected to Wi-Fi network',
        'doorOpened': 'The door is open',
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
        'es': 'Spanish',
        'en': 'English',
        'other': 'English',
      },
    );
    return '$_temp0';
  }

  @override
  String get mailboxSettingsTitle => 'Mailbox settings';

  @override
  String get mailboxNameLabel => 'Mailbox Name';

  @override
  String get mailboxNameHint => 'Please enter a name';

  @override
  String get notificationsEnabledLabel => 'Notifications enabled';

  @override
  String get notificationLanguageLabel => 'Notification language';

  @override
  String get saveSettingsButton => 'Save settings';

  @override
  String get settingsSavedSuccess => 'Settings saved successfully';

  @override
  String get settingsSavedError => 'Error saving settings';
}
