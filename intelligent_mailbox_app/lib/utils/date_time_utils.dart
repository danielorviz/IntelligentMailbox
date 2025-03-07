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
}
