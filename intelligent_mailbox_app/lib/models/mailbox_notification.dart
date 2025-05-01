import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class MailboxNotification {
  
  static const int typeKey = 0;//'KEY';
  static const int typePackage = 1;//'PACKAGE';
  static const int typeLetter = 2;//'LETTER';
  static const int typeMailbox = 3;//'MAILBOX';
  static const int typeKeyFailed = 4;//'KEY_FAILED';
  static const int typePackageFailed = 5;//'PACKAGE_FAILED';

  final String title;
  final String message;
  final int time;
  final String mailboxId;
  final int type;
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
      type: json['type']?? -1,
      typeInfo: json['typeInfo'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  DateTime getTimeWithOffset() {
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(time);
  }

  String getTypeInfoName(){
    if(typeInfo.contains('.;.')){
      return typeInfo.split('.;.')[1];
    }
    return typeInfo;
  }
}