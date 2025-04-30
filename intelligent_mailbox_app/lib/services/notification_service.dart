import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

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
    int? type,
  ) {
    if (mailboxId == null || mailboxId.isEmpty) return Stream.value(null);
    int limit = type != null ? 100 : 1;
    return _database
        .child('notifications')
        .child(mailboxId)
        .orderByChild('time')
        .limitToLast(limit)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map?;
          if (data == null) return null;

          if (type == null) {
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

  Future<int> getFirstNotificationTime(String? mailboxId) async {
    if (mailboxId == null || mailboxId.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch;
    }
    try {
      final snapshot =
          await _database
              .child('notifications')
              .child(mailboxId)
              .orderByChild('time')
              .limitToFirst(1)
              .get();
      final data = snapshot.value as Map?;
      if (data == null || data.isEmpty) return DateTime.now().millisecondsSinceEpoch;

      final firstNotification = data.values.first as Map<dynamic, dynamic>;
      return (firstNotification['time'] as int?)! * 1000;
    } catch (error) {
      print('Error getting first notification time: $error');
      return 0;
    }
  }

  Stream<List<int>> getWeeklyCountsByMonth({
    required String? mailboxId,
    required int year,
    required int month,
  }) {
    if (mailboxId == null || mailboxId.isEmpty) {
      return Stream.value(List<int>.filled(7, 0));
    }

    return _database.child('notifications').child(mailboxId).onValue.map((
      event,
    ) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return List<int>.filled(7, 0);

      final notifications = data.values
          .map(
            (entry) =>
                MailboxNotification.fromJson(Map<String, dynamic>.from(entry)),
          )
          .where((noti) {
            final date = DateTime.fromMillisecondsSinceEpoch(
              noti.time * 1000,
            );
            return date.year == year && date.month == month;
          });

      final Map<int, int> dayCounts = {for (int i = 0; i < 7; i++) i: 0};

      for (final noti in notifications) {
        final date = DateTime.fromMillisecondsSinceEpoch(
          noti.time * 1000,
        );
        int dayOfWeek = date.weekday - 1; // Lunes es 0, Domingo es 6
        dayCounts[dayOfWeek] = (dayCounts[dayOfWeek] ?? 0) + 1;
      }

      return dayCounts.values.toList(); // Retornar conteos como lista
    });
  }

  Future<void> activateDeactivateMailboxNotifications(String? mailboxId, bool active) async {
    if (kIsWeb) return;
    if (mailboxId == null || mailboxId.isEmpty) return;
    try {
      if (active) {
        await FirebaseMessaging.instance.subscribeToTopic(mailboxId);
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(mailboxId);
      }
    } catch (error) {
      print('Error al activar las notificaciones: $error');
    }
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Este método se ejecuta cuando se recibe una notificación en segundo plano
    print('Mensaje recibido en segundo plano: ${message.notification?.title}}');
  }

  Future<void> initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        "Message received while in foreground: ${message.notification?.title}",
      );
    });
    await requestNotificationPermissions();
  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permisos de notificaciones concedidos.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permisos provisionales concedidos.');
    } else {
      print('Permisos de notificaciones denegados.');
    }
  }
  Future<void> markAllAsRead(String mailboxId) async {
    try {
      final notificationsRef = _database.child('notifications').child(mailboxId);

      final snapshot = await notificationsRef.once();

      if (snapshot.snapshot.value != null) {
        final notificationsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;

        notificationsMap.forEach((key, value) async {
          if (value['isRead'] != true) {
            await notificationsRef.child(key).update({
              'isRead': true,
            });
          }
        });
      } 
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
}
