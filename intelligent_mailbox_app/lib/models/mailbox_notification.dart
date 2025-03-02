class MailboxNotification {

  final String title;
  final String message;
  final DateTime time;
  final String mailboxId;

  MailboxNotification({required this.title, required this.message, required this.time, required this.mailboxId});

  factory MailboxNotification.fromJson(Map<dynamic, dynamic> json) {
    return MailboxNotification(
      title: json['titulo'],
      message: json['mensaje'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000),
      mailboxId: json['mailbox'],

    );
  }
}