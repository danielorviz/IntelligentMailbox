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

  MailboxProvider(this._userProvider) {
    _loadMailboxes();
  }

  List<Mailbox> get mailboxes => _mailboxes;
  Mailbox? get selectedMailbox => _selectedMailbox;

    Future<void> _loadMailboxes() async {
    final user = _userProvider.user;
    if (user != null) {
      try {
        _mailboxService.getUserMailboxKeys(user.uid).listen((mailboxKeys) {
          final mailboxStreams = mailboxKeys.map((key) => _mailboxService.getMailboxDetails(key));
          CombineLatestStream.list(mailboxStreams).listen((mailboxes) {
            _mailboxes = mailboxes;
            if (_mailboxes.isNotEmpty && _selectedMailbox == null) {
              selectMailbox(_mailboxes.first);
            }
            notifyListeners();
          });
        }, onError: (error) {
          print('Error listening to mailbox keys: $error');
        });
      } catch (e) {
        print('Error loading mailboxes: $e');
      }
    } else {
      print('User is null');
    }
  }

  Future<void> selectMailbox(Mailbox mailbox) async {
    try {
      _selectedMailbox = mailbox;
      notifyListeners();
    } catch (e) {
      print('Error selecting mailbox: $e');
    }
  }
}