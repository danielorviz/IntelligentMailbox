import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/models/mailbox_initial_config.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:intelligent_mailbox_app/utils/constants.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class MailboxService {
  static final MailboxService _instance = MailboxService._internal();

  MailboxService._internal();

  factory MailboxService() {
    return _instance;
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<String>> getUserMailboxKeys(String userId) {
    try {
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
    } catch (error) {
      return Stream.value([]);
    }
  }

  Stream<Mailbox?> getMailboxDetails(String mailboxId) {
    try {
      return _database.child('mailbox').child(mailboxId).onValue.map((event) {
        final value = event.snapshot.value;

        if (value == null) {
          return null;
        }
        final mailboxData = Map<String, dynamic>.from(
          value as Map<dynamic, dynamic>,
        );
        return Mailbox.fromMap(mailboxData, mailboxId);
      });
    } catch (error) {
      return Stream.value(null);
    }
  }

  Future<Map<String, dynamic>> getMailboxContent(String mailboxId) async {
    try {
      final snapshot =
          await _database.child('mailboxes').child(mailboxId).once();
      final value = snapshot.snapshot.value;
      if (value == null) {
        return {};
      }
      return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
    } catch (error) {
      print('Error getting mailbox content: $error');
      return {};
    }
  }

  Future<void> checkMailboxConnection(String mailboxId) async {
    final mailboxRef = FirebaseDatabase.instance.ref('mailbox/$mailboxId');

    await mailboxRef.update({'wifiStatus': Constants.connectionChecking});

    mailboxRef.update({
      'lastWifiStatusCheck': DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(
        DateTime.now(),
      ),
    });

    const timeoutDuration = Duration(seconds: 10);

    bool connectionSuccess = false;

    final Completer<void> completer = Completer<void>();

    StreamSubscription? connectionStatusListener;

    try {
      connectionStatusListener = mailboxRef.child('wifiStatus').onValue.listen((
        event,
      ) {
        final data = event.snapshot.value;

        if (data == Constants.connectionSuccess) {
          connectionSuccess = true;
          completer.complete();
        }
      });

      await Future.any([
        Future.delayed(timeoutDuration),
        completer.future,
      ]);

      if (!connectionSuccess) {
        await mailboxRef.update({'wifiStatus': Constants.connectionFailed});
        print("Conexión fallida después de 10 segundos.");
      } else {
        print("Conexión establecida con éxito.");
      }
    } finally {
      await connectionStatusListener?.cancel();
    }
  }

  Stream<List<MailboxNotification>> getNotifications(String? mailboxId) {
    if (mailboxId == null || mailboxId.isEmpty) return Stream.value([]);
    try {
      return _database.child('notifications').child(mailboxId).onValue.map((
        event,
      ) {
        final notificationsMap = event.snapshot.value as Map<dynamic, dynamic>?;
        if (notificationsMap == null) {
          return <MailboxNotification>[];
        }
        List<MailboxNotification> notifications = [];
        notificationsMap.forEach((key, value) {
          notifications.add(
            MailboxNotification.fromJson(value as Map<dynamic, dynamic>),
          );
        });
        notifications.sort((a, b) => b.time.compareTo(a.time));
        return notifications;
      });
    } catch (error) {
      print('Error getting notifications: $error');
      return Stream.value([]);
    }
  }

  Stream<MailboxNotification?> getLastNotificationByType(
    String? mailboxId,
    String? type,
  ) {
    if (mailboxId == null || mailboxId.isEmpty) return Stream.value(null);
    int limit = type != null ? 100 : 1;
    return _database
        .child('notifications')
        .child(mailboxId)
        .orderByChild('time')
        .limitToFirst(limit)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map?;
          if (data == null) return null;

          if (type == null || type.isEmpty) {
            final notificaciones =
                data.entries
                    .map((entry) => Map<String, dynamic>.from(entry.value))
                    .toList();
            notificaciones.sort(
              (a, b) => (b['time'] as int).compareTo(a['time'] as int),
            );
            return MailboxNotification.fromJson(notificaciones[0]);
          }
          final notificaciones =
              data.entries
                  .map((entry) => Map<String, dynamic>.from(entry.value))
                  .where((noti) => noti['type'] == type)
                  .toList();
          notificaciones.sort(
            (a, b) => (b['time'] as int).compareTo(a['time'] as int),
          );

          return MailboxNotification.fromJson(notificaciones[0]);
        });
  }

  Future<void> createMailbox(
    String mailboxId,
    String userId,
    int offset,
  ) async {
    try {
      await FirebaseDatabase.instance.ref("mailbox/$mailboxId").update({
        "name": mailboxId,
        "id": mailboxId,
        "instructions/offset": offset,
        "instructions/open": false,
        "users": {userId: true},
      });
      await FirebaseDatabase.instance
          .ref("users/$userId/mailbox/$mailboxId")
          .set(true);
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow;
    }
  }

  Future<void> saveSettings(
    String mailboxId,
    String mailboxName,
    int offset,
  ) async {
    try {
      await FirebaseDatabase.instance
          .ref("mailbox/$mailboxId/name")
          .set(mailboxName);
      await FirebaseDatabase.instance
          .ref("mailbox/$mailboxId/instructions/offset")
          .set(offset);
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow;
    }
  }

  Future<void> createAuthorizedKey(
    String mailboxId,
    AuthorizedKey authorizedKey,
  ) async {
    DatabaseReference authKeys = FirebaseDatabase.instance.ref(
      "mailbox/$mailboxId/authorizedkeys",
    );
    try {
      await authKeys.push().set(authorizedKey.toMap());
    } catch (error) {
      print('Failed to create AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedKey(
    String mailboxId,
    AuthorizedKey authorizedKey,
  ) async {
    try {
      await FirebaseDatabase.instance
          .ref("mailbox/$mailboxId/authorizedkeys/${authorizedKey.id}")
          .update(authorizedKey.toMap());
    } catch (error) {
      print('Failed to update AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedKey(
    String mailboxId,
    String authorizedKeyId,
  ) async {
    try {
      await _database
          .child('mailbox/$mailboxId/authorizedkeys/$authorizedKeyId')
          .remove();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createAuthorizedPackage(
    String mailboxId,
    AuthorizedPackage authorizedPackage,
  ) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref(
      "mailbox/$mailboxId/authorizedPackages",
    );
    try {
      await authPackage.push().set(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to create AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedPackage(
    String mailboxId,
    AuthorizedPackage authorizedPackage,
  ) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref(
      "mailbox/$mailboxId/authorizedPackages/${authorizedPackage.id}",
    );
    try {
      await authPackage.update(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to update AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedPackage(
    String mailboxId,
    String authorizedPackageId,
  ) async {
    try {
      await _database
          .child('mailbox/$mailboxId/authorizedPackages/$authorizedPackageId')
          .remove();
    } catch (error) {
      rethrow;
    }
  }

  Future<MailboxInitialConfig?> getMailboxInitializer(
    String mailboxId,
    String key,
  ) async {
    try {
      final configuration =
          await _database.child('configuration/mailboxes/$mailboxId').get();
      if (configuration.value != null) {
        final data = Map<String, dynamic>.from(
          configuration.value as Map<dynamic, dynamic>,
        );
        if (data["key"] == null || data["key"] != key) {
          return null;
        }
        return MailboxInitialConfig.fromMap(data, mailboxId);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
