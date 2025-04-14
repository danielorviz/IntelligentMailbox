import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'dart:math';
import 'package:intelligent_mailbox_app/pages/configuration/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/pages/configuration/new_mailbox_configuration_screen.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onSignOut;

  const DrawerMenu({super.key, required this.onSignOut});

  Color _getColorForMailbox(String mailboxId) {
    final random = Random(mailboxId.hashCode);
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: DrawerHeader(
              decoration: BoxDecoration(color: CustomColors.primaryBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.hello(userProvider.user?.displayName ?? ''),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  userProvider.user?.photoURL != null
                      ? ClipOval(
                        child: Image.network(
                          userProvider.user!.photoURL!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const ClipOval(
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                  const SizedBox(height: 10),
                  Text(
                    userProvider.user?.email ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.markunread_mailbox, size: 25),
                  title: Text(AppLocalizations.of(context)!.mailboxes),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const NewMailboxConfigurationScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Consumer<MailboxProvider>(
                  builder: (context, mailboxProvider, child) {
                    Provider.of<PreferencesProvider>(
                      context,
                      listen: false,
                    ).loadPreferences(
                      userProvider.user?.uid ?? '',
                      mailboxProvider.selectedMailbox?.id ?? '',
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          mailboxProvider.mailboxes.map((Mailbox mailbox) {
                            final isSelected =
                                mailboxProvider.selectedMailbox?.id ==
                                mailbox.id;

                            final color = _getColorForMailbox(mailbox.id);

                            return ListTile(
                              leading: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    mailbox.name.isNotEmpty
                                        ? mailbox.name[0]
                                        : mailbox.id[0],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              tileColor:
                                  isSelected
                                      ? CustomColors.primaryBlue.withAlpha(20)
                                      : null,
                              title: Text(
                                mailbox.name,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? CustomColors.primaryBlue
                                          : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                mailboxProvider.selectMailbox(mailbox);
                                Navigator.of(context).pop();
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<PreferencesProvider>(
                                    builder: (context, preferences, child) {
                                      final isEnabled = preferences
                                          .isNotificationEnabled(
                                            userProvider.user?.uid ?? '',
                                            mailbox.id,
                                          );

                                      return IconButton(
                                        onPressed: () {
                                          preferences.updateNotificationState(
                                            userProvider.user?.uid ?? '',
                                            mailbox.id,
                                            !isEnabled,
                                          );
                                        },
                                        icon: Icon(
                                          isEnabled
                                              ? Icons.notifications_active
                                              : Icons.notifications_off,
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  MailboxSettingsScreen(
                                                    mailbox: mailbox,
                                                  ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.settings, size: 20),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red, size: 25,),
            title: Text(
              AppLocalizations.of(context)!.signout,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    title: AppLocalizations.of(context)!.signout,
                    content: AppLocalizations.of(context)!.signOutConfirm,
                    cancelText: AppLocalizations.of(context)!.cancel,
                    confirmText: AppLocalizations.of(context)!.confirm,
                  );
                },
              );
              if (confirm == true) {
                onSignOut();
                if(context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
