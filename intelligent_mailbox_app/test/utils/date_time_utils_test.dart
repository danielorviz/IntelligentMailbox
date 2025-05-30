import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateTimeUtils', () {
    test('formatDate returns correct string', () {
      final date = DateTime(2023, 5, 10);
      expect(
        DateTimeUtils.formatDate(date),
        DateFormat('dd-MM-yyyy').format(date),
      );
    });

    test('formatTime returns correct string', () {
      final date = DateTime(2023, 5, 10, 14, 30);
      expect(DateTimeUtils.formatTime(date), DateFormat('HH:mm').format(date));
    });

    test('getUnixTimestampWithoutTimezoneOffset returns 0 if null', () {
      expect(DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(null), 0);
    });

    test('getUnixTimestampWithoutTimezoneOffset returns correct value', () {
      final date = DateTime.utc(2023, 5, 10, 14, 30, 0);
      final expected = date.millisecondsSinceEpoch ~/ 1000;
      expect(
        DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(date),
        expected,
      );
    });

    test('getDateTimeFromSecondsAndOffset returns correct DateTime', () {
      final seconds = 1683729000; // 2023-05-10 14:30:00 UTC
      final dt = DateTimeUtils.getDateTimeFromSecondsAndOffset(seconds);
      expect(dt, isA<DateTime>());
      expect(dt.millisecondsSinceEpoch ~/ 1000, seconds);
    });

    test('hasExpired returns true if now > finishDate', () {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(DateTimeUtils.hasExpired(now - 10, now - 1), true);
    });

    test('hasExpired returns true if now < initDate', () {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(DateTimeUtils.hasExpired(now + 10, now + 20), true);
    });

    test('hasExpired returns false if now in range', () {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(DateTimeUtils.hasExpired(now - 10, now + 10), false);
    });
    test('formatDate handles min and max dates', () {
      expect(DateTimeUtils.formatDate(DateTime(1970, 1, 1)), '01-01-1970');
      expect(DateTimeUtils.formatDate(DateTime(9999, 12, 31)), '31-12-9999');
    });

    test('getUnixTimestampWithoutTimezoneOffset handles timezones', () {
      final date = DateTime(2023, 5, 10, 12, 0, 0).toUtc();
      expect(
        DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(date),
        date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('getDateTimeFromSecondsAndOffset with zero and negative', () {
      final dt = DateTimeUtils.getDateTimeFromSecondsAndOffset(0);
      expect(dt.year, 1970);
      final dtNeg = DateTimeUtils.getDateTimeFromSecondsAndOffset(-1000);
      expect(dtNeg.isBefore(DateTime.utc(1970)), true);
    });

    test('hasExpired with equal init and finish date', () {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(DateTimeUtils.hasExpired(now, now), false);
    });

    test('hasExpired with initDate > finishDate', () {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(DateTimeUtils.hasExpired(now + 10, now - 10), true);
    });
  });
}
