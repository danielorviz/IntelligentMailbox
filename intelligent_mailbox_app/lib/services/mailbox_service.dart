import 'package:firebase_database/firebase_database.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';

class MailboxService {

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<String>> getUserMailboxKeys(String userId) {
    return _database
        .child('users')
        .child(userId)
        .child('mailbox')
        .onValue
        .map((event) {
      final mailboxesMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (mailboxesMap == null) {
        return <String>[];
      }
      List<String> mailboxKeys = [];
      mailboxesMap.forEach((key, value) {
        print('key: $key, value: $value');
        if (value == true) {
          mailboxKeys.add(key);
        }
      });
      print(mailboxKeys);
      return mailboxKeys;
    });
  }

  Stream<Mailbox> getMailboxDetails(String mailboxId) {
    return _database
        .child('mailbox')
        .child(mailboxId)
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      print('value $value');

      if (value == null) {
        throw Exception('Mailbox not found');
      }
      final mailboxData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
      return Mailbox.fromMap(mailboxData, mailboxId);
    });
  }

  Future<Map<String, dynamic>> getMailboxContent(String mailboxId) async {
    final snapshot = await _database.child('mailboxes').child(mailboxId).once();
    final value = snapshot.snapshot.value;
    if (value == null) {
      return {};
    }
    print(value);
    return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
  }

  Stream<List<MailboxNotification>> getNotifications(String mailboxId) {
    return _database
        .child('notifications')
        .child(mailboxId)
        .onValue
        .map((event) {
      final notificationsMap = event.snapshot.value as Map<dynamic, dynamic>?;
      print('notificationsMap: $notificationsMap');
      if (notificationsMap == null) {
        return <MailboxNotification>[];
      }
      List<MailboxNotification> notifications = [];
      notificationsMap.forEach((key, value) {
          notifications.add(MailboxNotification.fromJson(value as Map<dynamic, dynamic>));
      });
      print(notifications);
      return notifications;
    });
  }
}