import 'package:flutter/foundation.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';

class Constants {
  static const String connectionChecking = 'CHECKING';
  static const String connectionFailed = 'FAILED';
  static const String connectionSuccess = 'SUCCESS';

  static const int doorClosed = 0;
  static const int doorOpened = 1;

  static String getDefaultLocale() {
    String languageCode = PlatformDispatcher.instance.locale.languageCode;
    return AppLocalizations.supportedLocales.contains(languageCode)
        ? languageCode
        : AppLocalizations.supportedLocales.first.languageCode;
  }
}
