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
    int timezoneOffsetSeconds,
  ) {
    DateTime utcDateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    );

    return utcDateTime.add(Duration(seconds: timezoneOffsetSeconds));
  }

  static bool hasExpired(int initDate, int finishDate, int offsetInSeconds) {
    final int currentTimeInSeconds =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    return currentTimeInSeconds > finishDate || currentTimeInSeconds < initDate;
  }

  static List<Map<String, dynamic>> getOffsetOptions(BuildContext context) {
    return [
      {'label': AppLocalizations.of(context)!.utc12, 'value': -43200},
      {'label': AppLocalizations.of(context)!.utc11, 'value': -39600},
      {'label': AppLocalizations.of(context)!.utc10, 'value': -36000},
      {'label': AppLocalizations.of(context)!.utc09, 'value': -32400},
      {'label': AppLocalizations.of(context)!.utc08, 'value': -28800},
      {'label': AppLocalizations.of(context)!.utc07, 'value': -25200},
      {'label': AppLocalizations.of(context)!.utc06, 'value': -21600},
      {'label': AppLocalizations.of(context)!.utc05, 'value': -18000},
      {'label': AppLocalizations.of(context)!.utc04, 'value': -14400},
      {'label': AppLocalizations.of(context)!.utc03, 'value': -10800},
      {'label': AppLocalizations.of(context)!.utc02, 'value': -7200},
      {'label': AppLocalizations.of(context)!.utc00, 'value': 0},
      {'label': AppLocalizations.of(context)!.utc01, 'value': 3600},
      {'label': AppLocalizations.of(context)!.utc02_2, 'value': 7200},
      {'label': AppLocalizations.of(context)!.utc03_2, 'value': 10800},
      {'label': AppLocalizations.of(context)!.utc04_2, 'value': 14400},
      {'label': AppLocalizations.of(context)!.utc05_2, 'value': 18000},
      {'label': AppLocalizations.of(context)!.utc06_2, 'value': 21600},
      {'label': AppLocalizations.of(context)!.utc07_2, 'value': 25200},
      {'label': AppLocalizations.of(context)!.utc08_2, 'value': 28800},
      {'label': AppLocalizations.of(context)!.utc09_2, 'value': 32400},
      {'label': AppLocalizations.of(context)!.utc10_2, 'value': 36000},
      {'label': AppLocalizations.of(context)!.utc11_2, 'value': 39600},
      {'label': AppLocalizations.of(context)!.utc12_2, 'value': 43200},
    ];
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

  static String getOffsetStringValue(BuildContext context, int mailboxOffset) {
    return DateTimeUtils.getOffsetOptions(context)
        .firstWhere(
          (offset) => offset['value'] == mailboxOffset,
          orElse: () => {'value': '0'},
        )['value']
        .toString();
  }

  static String getOffsetStringLabel(BuildContext context, int mailboxOffset) {
    return DateTimeUtils.getOffsetOptions(context)
        .firstWhere(
          (offset) => offset['value'] == mailboxOffset,
          orElse: () => {'value': '0'},
        )['label']
        .toString();
  }
}
