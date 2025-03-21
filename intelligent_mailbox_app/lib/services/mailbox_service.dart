import 'package:firebase_database/firebase_database.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';

class MailboxService {

  static final MailboxService _instance = MailboxService._internal();

  MailboxService._internal();

  factory MailboxService() {
    return _instance;
  }

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
        if (value == true) {
          mailboxKeys.add(key);
        }
      });
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
    return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
  }

  Stream<List<MailboxNotification>> getNotifications(String mailboxId) {
    return _database
        .child('notifications')
        .child(mailboxId)
        .onValue
        .map((event) {
      final notificationsMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (notificationsMap == null) {
        return <MailboxNotification>[];
      }
      List<MailboxNotification> notifications = [];
      notificationsMap.forEach((key, value) {
          notifications.add(MailboxNotification.fromJson(value as Map<dynamic, dynamic>));
      });
      return notifications;
    });
  }
  Future<void> createMailbox(String mailboxId, String userId, int offset) async{
    try {
      await FirebaseDatabase.instance.ref("mailbox/$mailboxId").update({
        "name": mailboxId,
        "id": mailboxId, 
        "instructions/offset": offset,
        "instructions/open": false,
        "users": {
          userId: true,
        },
      });
      await FirebaseDatabase.instance.ref("users/$userId/mailbox/$mailboxId").set(true);
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow; 
    }
  }

  Future<void> saveSettings(String mailboxId, String mailboxName, int offset) async{
    try {
      await FirebaseDatabase.instance.ref("mailbox/$mailboxId/name").set(mailboxName);
      await FirebaseDatabase.instance.ref("mailbox/$mailboxId/instructions/offset").set(offset);
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow; 
    }
  }

 Future<void> createAuthorizedKey(String mailboxId, AuthorizedKey authorizedKey) async {
    DatabaseReference authKeys = FirebaseDatabase.instance.ref("mailbox/$mailboxId/authorizedkeys");
    try {
      await authKeys.push().set(authorizedKey.toMap());
    } catch (error) {
      print('Failed to create AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedKey(String mailboxId, AuthorizedKey authorizedKey) async {
    try {
      await FirebaseDatabase.instance.ref("mailbox/$mailboxId/authorizedkeys/${authorizedKey.id}").update(authorizedKey.toMap());
    } catch (error) {
      print('Failed to update AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedKey(String mailboxId, String authorizedKeyId) async {
    try {
      await _database.child('mailbox/$mailboxId/authorizedkeys/$authorizedKeyId').remove();
    } catch (error) {
      rethrow;
    }
  }

   Future<void> createAuthorizedPackage(String mailboxId, AuthorizedPackage authorizedPackage) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref("mailbox/$mailboxId/authorizedPackages");
    try {
      await authPackage.push().set(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to create AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedPackage(String mailboxId, AuthorizedPackage authorizedPackage) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref("mailbox/$mailboxId/authorizedPackages/${authorizedPackage.id}");
    try {
      await authPackage.update(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to update AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedPackage(String mailboxId, String authorizedPackageId) async {
    try {
      await _database.child('mailbox/$mailboxId/authorizedPackages/$authorizedPackageId').remove();
    } catch (error) {
      rethrow;
    }
  }
}