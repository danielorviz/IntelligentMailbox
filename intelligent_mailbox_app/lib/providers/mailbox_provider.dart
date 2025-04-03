import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:rxdart/rxdart.dart';

class MailboxProvider with ChangeNotifier {
  final UserProvider _userProvider;
  final MailboxService _mailboxService = MailboxService();

  List<Mailbox> _mailboxes = [];
  Mailbox? _selectedMailbox;
  final List<StreamSubscription> _subscriptions = []; // Lista para almacenar todas las suscripciones

  MailboxProvider(this._userProvider) {
    _loadMailboxes();
  }

  List<Mailbox> get mailboxes => _mailboxes;
  Mailbox? get selectedMailbox => _selectedMailbox;

  Future<void> _loadMailboxes() async {
    final user = _userProvider.user;
    if (user != null) {
      try {
        final mailboxKeysStream = _mailboxService.getUserMailboxKeys(user.uid);
        final mailboxKeysSubscription = mailboxKeysStream.listen(
          (mailboxKeys) {
            if (mailboxKeys.isEmpty && _mailboxes.isNotEmpty) {
              _mailboxes = [];
              _selectedMailbox = null;
              notifyListeners();
              return;
            }

            final mailboxStreams = mailboxKeys.map((key) => _mailboxService.getMailboxDetails(key));
            final combinedStream = CombineLatestStream.list(mailboxStreams);

            final combinedSubscription = combinedStream.listen((mailboxes) {
              _mailboxes = mailboxes.whereType<Mailbox>().toList();
              print('Cargando mailboxes: $mailboxes');
              if (_mailboxes.isNotEmpty) {
                selectMailbox(_mailboxes.first);
              } else if (_mailboxes.isEmpty) {
                _selectedMailbox = null;
              }
              notifyListeners();
            });

            // Agrega la suscripción combinada a la lista
            _subscriptions.add(combinedSubscription);
          },
          onError: (error) {
            print('Error listening to mailbox keys: $error');
          },
        );

        // Agrega la suscripción principal a la lista
        _subscriptions.add(mailboxKeysSubscription);
      } catch (e) {
        print('Error loading mailboxes: $e');
      }
    } else {
      print('User is null');
    }
  }

  Future<void> selectMailbox(Mailbox? mailbox) async {
    try {
      if (_selectedMailbox == mailbox) {
        return; // Ya está seleccionado, no hacer nada
      }
      _selectedMailbox = mailbox;
      notifyListeners();
    } catch (e) {
      print('Error selecting mailbox: $e');
    }
  }

  Future<void> signOut() async {
    // Cancela todas las suscripciones activas
    await _cancelAllSubscriptions();

    // Limpia los datos
    _mailboxes = [];
    _selectedMailbox = null;

    // Notifica cambios
    notifyListeners();
  }

  Future<void> _cancelAllSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear(); // Limpia la lista de suscripciones
  }
}
