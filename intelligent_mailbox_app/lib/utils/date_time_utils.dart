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

    final int timeZoneOffsetInSeconds = date.timeZoneOffset.inSeconds;

    final DateTime utcDateTime = date.subtract(
      Duration(seconds: timeZoneOffsetInSeconds),
    );

    return utcDateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static DateTime getDateTimeFromSecondsAndOffset(
    int dateInSeconds,
    int offsetInSeconds,
  ) {
    return DateTime.fromMillisecondsSinceEpoch(
      dateInSeconds * 1000,
    ).add(Duration(seconds: offsetInSeconds));
  }

  static bool hasExpired(int initDate, int finishDate, int offsetInSeconds) {
    final int currentTimeInSeconds =
        DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int adjustedCurrentTime = currentTimeInSeconds - offsetInSeconds;

    return adjustedCurrentTime > finishDate || adjustedCurrentTime < initDate;
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
