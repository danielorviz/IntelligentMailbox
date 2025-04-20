import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat timeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime dateTime) {
    return dateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return timeFormat.format(dateTime);
  }

  static int getUnixTimestampWithoutTimezoneOffset(DateTime? date) {
    if (date == null) return 0;
    final DateTime utcDateTime = date.toUtc();

    return utcDateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static DateTime getDateTimeFromSecondsAndOffset(
    int seconds,
  ) {
    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
    );

  }

  static bool hasExpired(int initDate, int finishDate) {
    final int currentTimeInSeconds =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    return currentTimeInSeconds > finishDate || currentTimeInSeconds < initDate;
  }

  static List<String> getMonths(BuildContext context) {
    return [
      AppLocalizations.of(context)!.january,
      AppLocalizations.of(context)!.february,
      AppLocalizations.of(context)!.march,
      AppLocalizations.of(context)!.april,
      AppLocalizations.of(context)!.may,
      AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july,
      AppLocalizations.of(context)!.august,
      AppLocalizations.of(context)!.september,
      AppLocalizations.of(context)!.october,
      AppLocalizations.of(context)!.november,
      AppLocalizations.of(context)!.december,
    ];
  }

  static List<String> getWeekDays(BuildContext context) {
    return [
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
    ];
  }

}
