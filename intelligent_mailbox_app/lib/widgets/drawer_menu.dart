import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onSignOut;

  DrawerMenu({
    super.key,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final selectedMailbox = mailboxProvider.selectedMailbox;
    final mailboxes = mailboxProvider.mailboxes;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Buzones'),
            trailing: DropdownButton<String>(
              value: selectedMailbox?.id,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged:(String? newValue) {
                if (newValue != null) {
                  final newMailbox = mailboxes.firstWhere((mailbox) => mailbox.id == newValue);
                  mailboxProvider.selectMailbox(newMailbox);
                }
              },
              items: mailboxes.map<DropdownMenuItem<String>>((Mailbox mailbox) {
                return DropdownMenuItem<String>(
                  value: mailbox.id,
                  child: Text(mailbox.name),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}