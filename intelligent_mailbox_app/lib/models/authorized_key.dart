import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class AuthorizedKey {
  final int initDate;
  final bool permanent;
  final String name;
  final int finishDate;
  final String id;
  final String value;

  AuthorizedKey({
    required this.initDate,
    required this.permanent,
    required this.name,
    required this.finishDate,
    required this.id,
    required this.value,
  });

  factory AuthorizedKey.fromMap(Map<dynamic, dynamic> data, String documentId) {
    return AuthorizedKey(
      initDate: data['initDate'] ?? 0,
      permanent: data['permanent'] ?? false,
      name: data['name'] ?? '',
      finishDate: data['finishDate'] ?? 0,
      id: documentId,
      value: data['value'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'initDate': initDate,
      'permanent': permanent,
      'name': name,
      'finishDate': finishDate,
      'value': value,
    };
  }

  DateTime getInitDateWithOffset(int offsetInSeconds) {
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(initDate, offsetInSeconds);
  }

  DateTime getFinishDateWithOffset(int offsetInSeconds) {
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(finishDate, offsetInSeconds);
  }

  bool isExpired(int offsetInSeconds) {
    return DateTimeUtils.hasExpired(initDate, finishDate, offsetInSeconds);
  }
}