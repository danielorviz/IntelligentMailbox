import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:rxdart/rxdart.dart';

class MailboxProvider with ChangeNotifier {
  final UserProvider _userProvider;
  final MailboxService _mailboxService = MailboxService();

  List<Mailbox> _mailboxes = [];
  Mailbox? _selectedMailbox;
  int _unreadCount = 0;
  final List<StreamSubscription> _subscriptions = [];

  MailboxProvider(this._userProvider) {
    loadMailboxes();
  }

  List<Mailbox> get mailboxes => _mailboxes;
  Mailbox? get selectedMailbox => _selectedMailbox;
  int get unreadNotifications => _unreadCount;

  Future<void> loadMailboxes() async {
    final user = _userProvider.user;
    if (user != null) {
      try {
        final mailboxKeysStream = _mailboxService.getUserMailboxKeys(user.uid);
        final mailboxKeysSubscription = mailboxKeysStream.listen(
          (mailboxKeys) {
            if (mailboxKeys.isEmpty && _mailboxes.isNotEmpty) {
              _mailboxes = [];
              _selectedMailbox = null;
              _safeNotifyListeners();
              return;
            }

            final mailboxStreams = mailboxKeys.map(
              (key) => _mailboxService.getMailboxDetails(key),
            );
            final combinedStream = CombineLatestStream.list(
              mailboxStreams,
            ).handleError((error) {
              print('Error in combined stream: $error');
            });

            final combinedSubscription = combinedStream.listen((mailboxes) {
              if (!hasListeners) return;
              _mailboxes = mailboxes.whereType<Mailbox>().toList();
              print('Cargando mailboxes: $mailboxes');
              if (_mailboxes.isNotEmpty) {
                if(selectedMailbox == null) {
                  selectMailbox(_mailboxes.first);
                }
              } else if (_mailboxes.isEmpty) {
                _selectedMailbox = null;
              }
              _safeNotifyListeners();
            });

            _subscriptions.add(combinedSubscription);
          },
          onError: (error) {
            print('Error listening to mailbox keys: $error');
          },
        );

        _subscriptions.add(mailboxKeysSubscription);
      } catch (e) {
        print('Error loading mailboxes: $e');
      }
    }
  }

  Future<void> _countUnreadNotifications() async {
    try {
      final notifCountSubscription = NotificationService()
          .getNotifications(_selectedMailbox?.id)
          .listen((notifications) {
            _unreadCount =
                notifications
                    .where((notification) => !notification.isRead)
                    .length;
            _safeNotifyListeners();
          });
      _subscriptions.add(notifCountSubscription);
      print('Counting unread notifications...');
    } catch (e) {
      print('Error counting unread notifications: $e');
    }
  }

  Future<void> selectMailbox(Mailbox? mailbox) async {
    try {
      if (_selectedMailbox == mailbox) {
        return;
      }
      _selectedMailbox = mailbox;
      _countUnreadNotifications();

      _safeNotifyListeners();
    } catch (e) {
      print('Error selecting mailbox: $e');
    }
  }

  Future<void> signOut() async {
    await _cancelAllSubscriptions();

    _mailboxes = [];
    _selectedMailbox = null;

    _safeNotifyListeners();
  }

  Future<void> _cancelAllSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  void _safeNotifyListeners() {
    if (hasListeners) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelAllSubscriptions();
    super.dispose();
  }
}
