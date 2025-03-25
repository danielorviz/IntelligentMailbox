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
  /// **'Packages'**
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
  /// **'No mailbox selected'**
  String get noMailboxSelected;

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
  /// **'Permanent key'**
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
  /// **'Has no authorized packages'**
  String get haveNoPackages;

  /// No description provided for @confirmDeleteAuthPackage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this authorized package?'**
  String get confirmDeleteAuthPackage;

  /// No description provided for @authPackageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Authorized package removed'**
  String get authPackageDeleted;

  /// No description provided for @editPackage.
  ///
  /// In en, this message translates to:
  /// **'Edit package'**
  String get editPackage;

  /// No description provided for @newPackage.
  ///
  /// In en, this message translates to:
  /// **'New package'**
  String get newPackage;

  /// No description provided for @packageCode.
  ///
  /// In en, this message translates to:
  /// **'Package code'**
  String get packageCode;

  /// No description provided for @enterPackageCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a package code'**
  String get enterPackageCode;

  /// No description provided for @permanentAccess.
  ///
  /// In en, this message translates to:
  /// **'Permanent access'**
  String get permanentAccess;

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
  /// **'Enter mailbox details'**
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
