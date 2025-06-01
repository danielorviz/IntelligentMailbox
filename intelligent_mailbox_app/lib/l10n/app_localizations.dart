import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Title for the app
  ///
  /// In en, this message translates to:
  /// **'Intelligent Mailbox'**
  String get appTitle;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello, World!'**
  String get helloWorld;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Hello {userName}'**
  String hello(String userName);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Accesses'**
  String get packages;

  /// No description provided for @keys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get keys;

  /// No description provided for @mail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get mail;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noMailboxSelected.
  ///
  /// In en, this message translates to:
  /// **'Add a mailbox to start managing it'**
  String get noMailboxSelected;

  /// No description provided for @noNotificationsFound.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet'**
  String get noNotificationsFound;

  /// No description provided for @confirmDeleteAuthKey.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this authorized key?'**
  String get confirmDeleteAuthKey;

  /// No description provided for @authKeyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Authorized key removed'**
  String get authKeyDeleted;

  /// No description provided for @permanentKey.
  ///
  /// In en, this message translates to:
  /// **'Permanent access'**
  String get permanentKey;

  /// No description provided for @mustSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'You must select a start date first'**
  String get mustSelectStartDate;

  /// No description provided for @endDateAfterStartDate.
  ///
  /// In en, this message translates to:
  /// **'The end date must be after the start date'**
  String get endDateAfterStartDate;

  /// No description provided for @endDateAndStartDateMandatory.
  ///
  /// In en, this message translates to:
  /// **'Start and end dates are mandatory'**
  String get endDateAndStartDateMandatory;

  /// No description provided for @successfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated'**
  String get successfullyUpdated;

  /// No description provided for @editKey.
  ///
  /// In en, this message translates to:
  /// **'Edit key'**
  String get editKey;

  /// No description provided for @newKey.
  ///
  /// In en, this message translates to:
  /// **'New key'**
  String get newKey;

  /// No description provided for @keyName.
  ///
  /// In en, this message translates to:
  /// **'Key name'**
  String get keyName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterName;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get enterValue;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @haveNoAuthKeys.
  ///
  /// In en, this message translates to:
  /// **'You have no authorized keys'**
  String get haveNoAuthKeys;

  /// No description provided for @haveNoPackages.
  ///
  /// In en, this message translates to:
  /// **'Has no authorized code'**
  String get haveNoPackages;

  /// No description provided for @confirmDeleteAuthPackage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this authorized code?'**
  String get confirmDeleteAuthPackage;

  /// No description provided for @authPackageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Authorized access removed'**
  String get authPackageDeleted;

  /// No description provided for @editPackage.
  ///
  /// In en, this message translates to:
  /// **'Edit access'**
  String get editPackage;

  /// No description provided for @newPackage.
  ///
  /// In en, this message translates to:
  /// **'New access'**
  String get newPackage;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get packageName;

  /// No description provided for @packageCode.
  ///
  /// In en, this message translates to:
  /// **'Access code'**
  String get packageCode;

  /// No description provided for @enterPackageCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a access code'**
  String get enterPackageCode;

  /// No description provided for @permanentAccess.
  ///
  /// In en, this message translates to:
  /// **'Permanent access'**
  String get permanentAccess;

  /// No description provided for @accessExpired.
  ///
  /// In en, this message translates to:
  /// **'Access expired'**
  String get accessExpired;

  /// No description provided for @accessActive.
  ///
  /// In en, this message translates to:
  /// **'Access active'**
  String get accessActive;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @packageAlreadyReceived.
  ///
  /// In en, this message translates to:
  /// **'The package has already been received'**
  String get packageAlreadyReceived;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending reception'**
  String get pending;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get status;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @wifiDisabled.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Disabled'**
  String get wifiDisabled;

  /// No description provided for @wifiDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi is disabled. Please enable it to continue.'**
  String get wifiDisabledMessage;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @arduinoAPConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the Arduino access point. Please check the connection and try again.'**
  String get arduinoAPConnectionError;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get incorrectCredentials;

  /// No description provided for @accountVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Account verification failed.'**
  String get accountVerificationError;

  /// No description provided for @mailboxNotFound.
  ///
  /// In en, this message translates to:
  /// **'Mailbox not found. Please check the ID and key.'**
  String get mailboxNotFound;

  /// No description provided for @informationVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Error verifying information.'**
  String get informationVerificationError;

  /// No description provided for @mailboxConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Error connecting to the mailbox'**
  String get mailboxConnectionError;

  /// No description provided for @wifiCredentialsError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Wi-Fi credentials'**
  String get wifiCredentialsError;

  /// No description provided for @mailboxConnectedWiFi.
  ///
  /// In en, this message translates to:
  /// **'Mailbox connected to the Wi-Fi network'**
  String get mailboxConnectedWiFi;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @connectNewMailbox.
  ///
  /// In en, this message translates to:
  /// **'Connect new mailbox'**
  String get connectNewMailbox;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify your account'**
  String get verifyYourAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @mailboxDetails.
  ///
  /// In en, this message translates to:
  /// **'Mailbox details'**
  String get mailboxDetails;

  /// No description provided for @enterMailboxDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter the mailbox data provided in the installation manual'**
  String get enterMailboxDetails;

  /// No description provided for @mailboxId.
  ///
  /// In en, this message translates to:
  /// **'Mailbox ID'**
  String get mailboxId;

  /// No description provided for @mailboxKey.
  ///
  /// In en, this message translates to:
  /// **'Mailbox key'**
  String get mailboxKey;

  /// No description provided for @connectToMailbox.
  ///
  /// In en, this message translates to:
  /// **'Connect to mailbox'**
  String get connectToMailbox;

  /// No description provided for @pleaseConnectManually.
  ///
  /// In en, this message translates to:
  /// **'Please, to continue, manually connect to the mailbox Wi-Fi network:'**
  String get pleaseConnectManually;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get passwordCopied;

  /// No description provided for @connectMailboxToWiFi.
  ///
  /// In en, this message translates to:
  /// **'Connect mailbox to the Wi-Fi network'**
  String get connectMailboxToWiFi;

  /// No description provided for @selectWiFiNetwork.
  ///
  /// In en, this message translates to:
  /// **'Select the Wi-Fi network to which you will connect your mailbox'**
  String get selectWiFiNetwork;

  /// No description provided for @scanNetworks.
  ///
  /// In en, this message translates to:
  /// **'Scan networks'**
  String get scanNetworks;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get finishSetup;

  /// No description provided for @congratulationsSetupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed the mailbox setup.'**
  String get congratulationsSetupCompleted;

  /// No description provided for @connectTo.
  ///
  /// In en, this message translates to:
  /// **'Connect to'**
  String get connectTo;

  /// No description provided for @manageSmartMailboxes.
  ///
  /// In en, this message translates to:
  /// **'Manage your smart mailboxes efficiently and securely with our app.'**
  String get manageSmartMailboxes;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Intelligent Mailbox. All rights reserved.'**
  String get copyright;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The password cannot be empty'**
  String get passwordCannotBeEmpty;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @emailCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The email cannot be empty'**
  String get emailCannotBeEmpty;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error logging in'**
  String get loginError;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @signout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signout;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. Please log in.'**
  String get signupSuccess;

  /// No description provided for @signupError.
  ///
  /// In en, this message translates to:
  /// **'Error creating account. Please try again.'**
  String get signupError;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordTooShort;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email address.'**
  String get userNotFound;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weakPassword;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Por favor, verifica tu correo electrónico antes de continuar.'**
  String get emailNotVerified;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Te hemos enviado un correo para restablecer tu contraseña.'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordResetError.
  ///
  /// In en, this message translates to:
  /// **'Ocurrió un error al intentar enviar el correo de recuperación.'**
  String get passwordResetError;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get passwordReset;

  /// No description provided for @passwordResetWillSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset email will be sent to'**
  String get passwordResetWillSent;

  /// No description provided for @enterEmailToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter an email to reset the password'**
  String get enterEmailToResetPassword;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info.'**
  String get info;

  /// No description provided for @mailboxConfig.
  ///
  /// In en, this message translates to:
  /// **'Mailbox configuration'**
  String get mailboxConfig;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check connection'**
  String get checkConnection;

  /// No description provided for @mailboxStatus.
  ///
  /// In en, this message translates to:
  /// **'Mailbox status'**
  String get mailboxStatus;

  /// No description provided for @checkingConnection.
  ///
  /// In en, this message translates to:
  /// **'Checking connection ...'**
  String get checkingConnection;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking ...'**
  String get checking;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @lastCheck.
  ///
  /// In en, this message translates to:
  /// **'Checked: '**
  String get lastCheck;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @lastKeyboardAccess.
  ///
  /// In en, this message translates to:
  /// **'Last keyboard access'**
  String get lastKeyboardAccess;

  /// No description provided for @lastScanAccess.
  ///
  /// In en, this message translates to:
  /// **'Last scan access'**
  String get lastScanAccess;

  /// No description provided for @lastNotificationReceived.
  ///
  /// In en, this message translates to:
  /// **'Last notification received'**
  String get lastNotificationReceived;

  /// No description provided for @noRecentInfo.
  ///
  /// In en, this message translates to:
  /// **'No recent information'**
  String get noRecentInfo;

  /// No description provided for @mailboxes.
  ///
  /// In en, this message translates to:
  /// **'Mailboxes'**
  String get mailboxes;

  /// No description provided for @addMailbox.
  ///
  /// In en, this message translates to:
  /// **'Add mailbox'**
  String get addMailbox;

  /// No description provided for @addMailboxFromApp.
  ///
  /// In en, this message translates to:
  /// **'To add a mailbox, access the mobile app'**
  String get addMailboxFromApp;

  /// No description provided for @chooseMailboxName.
  ///
  /// In en, this message translates to:
  /// **'Choose a name for your mailbox'**
  String get chooseMailboxName;

  /// No description provided for @registeringMailbox.
  ///
  /// In en, this message translates to:
  /// **'Register mailbox'**
  String get registeringMailbox;

  /// No description provided for @registeringMailboxDetails.
  ///
  /// In en, this message translates to:
  /// **'The mailbox data is being registered'**
  String get registeringMailboxDetails;

  /// No description provided for @mailboxRegistrationError.
  ///
  /// In en, this message translates to:
  /// **'Error registering the mailbox'**
  String get mailboxRegistrationError;

  /// No description provided for @nfcError.
  ///
  /// In en, this message translates to:
  /// **'Error scaning'**
  String get nfcError;

  /// No description provided for @nfcNotDetected.
  ///
  /// In en, this message translates to:
  /// **'No NFC tag detected'**
  String get nfcNotDetected;

  /// No description provided for @scanNfc.
  ///
  /// In en, this message translates to:
  /// **'Scan NFC'**
  String get scanNfc;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning ...'**
  String get scanning;

  /// No description provided for @nfcNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'NFC not available'**
  String get nfcNotAvailable;

  /// No description provided for @nfcOnlyInApp.
  ///
  /// In en, this message translates to:
  /// **'To scan, use the mobile app'**
  String get nfcOnlyInApp;

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @openDoor.
  ///
  /// In en, this message translates to:
  /// **'Open door'**
  String get openDoor;

  /// No description provided for @opened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get opened;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'closed'**
  String get closed;

  /// No description provided for @instructionSent.
  ///
  /// In en, this message translates to:
  /// **'Instruction sent'**
  String get instructionSent;

  /// No description provided for @confirmOpenDoor.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to open the door?'**
  String get confirmOpenDoor;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @notificationsStatistics.
  ///
  /// In en, this message translates to:
  /// **'Notifications Statistics'**
  String get notificationsStatistics;

  /// Notificación de nuevo correo
  ///
  /// In en, this message translates to:
  /// **'{title, select, packageNotRecognize{Package not recognized} packageRecived{Authorized package received} keyNFCAccess{NFC key access} newLetter{New letter received} mailboxFull{Mailbox full} mailboxOpened{Mailbox opened} mailboxOpenFailed{Mailbox opening attempt failed} mailboxConnected{Mailbox connected} doorOpened{The door is open} other{Notification}}'**
  String notificationTitle(String title);

  /// Notificación de nuevo correo
  ///
  /// In en, this message translates to:
  /// **'{message, select, packageNotRecognizeMessage{An attempt was made to open the door} packageRecivedMessage{Door opened with the package} keyNFCAccessMessage{Door opened with NFC key} newLetterMessage{You have received new mail} mailboxFullMessage{The mailbox might be full or mail has gotten stuck} mailboxOpenedMessage{Door opened with the key} mailboxOpenFailedMessage{An attempt was made to open the door} mailboxConnectedMessage{Mailbox connected to Wi-Fi network} doorOpened{The door is open} other{Notification}}'**
  String notificationMessage(String message);

  /// Selected language
  ///
  /// In en, this message translates to:
  /// **'{lang, select, es{Spanish} en{English} other{English}}'**
  String language(String lang);

  /// No description provided for @mailboxSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mailbox settings'**
  String get mailboxSettingsTitle;

  /// No description provided for @mailboxNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Mailbox Name'**
  String get mailboxNameLabel;

  /// No description provided for @mailboxNameHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get mailboxNameHint;

  /// No description provided for @notificationsEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabledLabel;

  /// No description provided for @notificationLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification language'**
  String get notificationLanguageLabel;

  /// No description provided for @saveSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettingsButton;

  /// No description provided for @settingsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSavedSuccess;

  /// No description provided for @settingsSavedError.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings'**
  String get settingsSavedError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
