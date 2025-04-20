import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class MailboxNotification {
  
  static const String typeKey = 'KEY';
  static const String typePackage = 'PACKAGE';
  static const String typeLetter = 'LETTER';
  static const String typeMailbox = 'MAILBOX';

  final String title;
  final String message;
  final int time;
  final String mailboxId;
  final String type;
  final String typeInfo;
  final bool isRead;

  MailboxNotification({required this.title, required this.message, required this.time, required this.mailboxId, 
  required this.type, required this.typeInfo, required this.isRead});

  factory MailboxNotification.fromJson(Map<dynamic, dynamic> json) {
    return MailboxNotification(
      title: json['titulo'],
      message: json['mensaje'],
      time: json['time'] ?? 0,
      mailboxId: json['mailbox'],
      type: json['type']?? '',
      typeInfo: json['typeInfo'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  DateTime getTimeWithOffset() {
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(time);
  }
}