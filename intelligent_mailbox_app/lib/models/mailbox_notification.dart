import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class MailboxNotification {

  final String title;
  final String message;
  final int time;
  final String mailboxId;
  final String type;
  final String typeInfo;

  MailboxNotification({required this.title, required this.message, required this.time, required this.mailboxId, required this.type, required this.typeInfo});

  factory MailboxNotification.fromJson(Map<dynamic, dynamic> json) {
    return MailboxNotification(
      title: json['titulo'],
      message: json['mensaje'],
      time: json['time'] ?? 0,
      mailboxId: json['mailbox'],
      type: json['type']?? '',
      typeInfo: json['typeInfo'] ?? '',
    );
  }

  DateTime getTimeWithOffset(int offsetInSeconds) {
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(time, offsetInSeconds);
  }
}