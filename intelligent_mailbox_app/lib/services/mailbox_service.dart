import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/models/mailbox_initial_config.dart';
import 'package:intelligent_mailbox_app/utils/constants.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class MailboxService {
  static final MailboxService _instance = MailboxService._internal();

  MailboxService._internal();

  factory MailboxService() {
    return _instance;
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<Mailbox>> getUserMailboxKeys(String userId) {
    try {
      return _database
          .child('users')
          .child(userId)
          .child('mailbox')
          .onValue
          .map((event) {
            final data = event.snapshot.value as Map?;
          if (data == null) return [];
            return data.entries
                .map((entry) {
                  final mailboxId = entry.key;
                  final mailboxData = Map<String, dynamic>.from(
                    entry.value as Map<dynamic, dynamic>,
                  );
                  return Mailbox.fromMap(mailboxData, mailboxId);
                })
                .toList();
          });
    } catch (error) {
      return Stream.value([]);
    }
  }

  Future<List<Mailbox>> fetchUserMailboxKeysOnce(String userId) async {
    return await getUserMailboxKeys(userId).first;
  }


  Future<void> checkMailboxConnection(String userId, String mailboxId) async {
    final mailboxRef = FirebaseDatabase.instance.ref('users/$userId/mailbox/$mailboxId');

    await mailboxRef.update({'wifiStatus': Constants.connectionChecking});

    mailboxRef.update({
      'lastWifiStatusCheck':
          DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(DateTime.now()),
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

      await Future.any([Future.delayed(timeoutDuration), completer.future]);

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

  Future<void> createMailbox(
    String mailboxId,
    String userId,
    int offset,
  ) async {
    try {
      await FirebaseDatabase.instance.ref("users/$userId/mailbox/$mailboxId").update({
        "name": mailboxId,
        "id": mailboxId,
        "instructions/offset": offset,
        "instructions/open": false,
        "users": {userId: true},
      });
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow;
    }
  }

  Future<void> saveSettings(
    String userId,
    String mailboxId,
    String mailboxName,
  ) async {
    try {
      await FirebaseDatabase.instance
          .ref("users/$userId/mailbox/$mailboxId/name")
          .set(mailboxName);
    } catch (error) {
      print('Failed to save settings: $error');
      rethrow;
    }
  }

  Future<void> createAuthorizedKey(
    String userId,
    String mailboxId,
    AuthorizedKey authorizedKey,
  ) async {
    DatabaseReference authKeys = FirebaseDatabase.instance.ref(
      "users/$userId/mailbox/$mailboxId/authorizedkeys",
    );
    try {
      await authKeys.push().set(authorizedKey.toMap());
    } catch (error) {
      print('Failed to create AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedKey(
    String userId,
    String mailboxId,
    AuthorizedKey authorizedKey,
  ) async {
    try {
      await FirebaseDatabase.instance
          .ref("users/$userId/mailbox/$mailboxId/authorizedkeys/${authorizedKey.id}")
          .update(authorizedKey.toMap());
    } catch (error) {
      print('Failed to update AuthorizedKey: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedKey(
    String userId,
    String mailboxId,
    String authorizedKeyId,
  ) async {
    try {
      await _database
          .child('users/$userId/mailbox/$mailboxId/authorizedkeys/$authorizedKeyId')
          .remove();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createAuthorizedPackage(
    String userId,
    String mailboxId,
    AuthorizedPackage authorizedPackage,
  ) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref(
      "users/$userId/mailbox/$mailboxId/authorizedPackages",
    );
    try {
      await authPackage.push().set(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to create AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> updateAuthorizedPackage(
    String userId,
    String mailboxId,
    AuthorizedPackage authorizedPackage,
  ) async {
    final DatabaseReference authPackage = FirebaseDatabase.instance.ref(
      "users/$userId/mailbox/$mailboxId/authorizedPackages/${authorizedPackage.id}",
    );
    try {
      await authPackage.update(authorizedPackage.toMap());
    } catch (error) {
      print('Failed to update AuthorizedPackage: $error');
      rethrow;
    }
  }

  Future<void> deleteAuthorizedPackage(
    String userId,
    String mailboxId,
    String authorizedPackageId,
  ) async {
    try {
      await _database
          .child('users/$userId/mailbox/$mailboxId/authorizedPackages/$authorizedPackageId')
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
