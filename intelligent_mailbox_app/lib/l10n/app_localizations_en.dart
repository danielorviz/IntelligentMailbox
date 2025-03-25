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
  String get permanentKey => 'Permanent key';

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
  String get selectDate => 'Select a date';

  @override
  String get save => 'Save';

  @override
  String get haveNoAuthKeys => 'You have no authorized keys';

  @override
  String get haveNoPackages => 'Has no authorized packages';

  @override
  String get confirmDeleteAuthPackage => 'Are you sure you want to delete this authorized package?';

  @override
  String get authPackageDeleted => 'Authorized package removed';

  @override
  String get editPackage => 'Edit package';

  @override
  String get newPackage => 'New package';

  @override
  String get packageCode => 'Package code';

  @override
  String get enterPackageCode => 'Please enter a package code';

  @override
  String get permanentAccess => 'Permanent access';

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
}
