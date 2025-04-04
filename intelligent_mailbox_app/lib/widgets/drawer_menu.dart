import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/pages/configuration/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/pages/configuration/new_mailbox_configuration_screen.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onSignOut;

  const DrawerMenu({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: CustomColors.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userProvider.user?.displayName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                userProvider.user?.photoURL != null
                    ? ClipOval(
                      child: Image.network(
                        userProvider.user!.photoURL!,
                        width: 100,
                        height: 100,
                      ),
                    )
                    : ClipOval(
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
              ],
            ),
          ),
          Consumer<MailboxProvider>(
            builder: (context, mailboxProvider, child) {
              return ListTile(
                leading: const Icon(Icons.mail),
                title: const Text('Buzones'),
                trailing:
                    mailboxProvider.mailboxes.isNotEmpty
                        ? DropdownButton<String>(
                          value:
                              mailboxProvider.mailboxes.any(
                                    (mailbox) =>
                                        mailbox.id == mailboxProvider.selectedMailbox?.id,
                                  )
                                  ? mailboxProvider.selectedMailbox?.id
                                  : null,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: CustomColors.primaryBlue,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              final newMailbox = mailboxProvider.mailboxes.firstWhere(
                                (mailbox) => mailbox.id == newValue,
                              );
                              mailboxProvider.selectMailbox(newMailbox);
                            }
                          },
                          items:
                              mailboxProvider.mailboxes.map<DropdownMenuItem<String>>((
                                Mailbox mailbox,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: mailbox.id,
                                  child: Text(
                                    mailbox.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                        )
                        : TextButton.icon(
                          onPressed: () => {print("pressed")},
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir buzón'),
                        ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MailboxSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Añadir buzón'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NewMailboxConfigurationScreen(),
                ),
              );
            },
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
