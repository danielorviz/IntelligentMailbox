import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class TopNavigation extends StatelessWidget {
  final VoidCallback onSignOut;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const TopNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Consumer<MailboxProvider>(
          builder: (context, mailboxProvider, child) {
            return mailboxProvider.mailboxes.isEmpty
                ? TextButton.icon(
                  onPressed:
                      () => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.addMailboxFromApp,
                            ),
                          ),
                        ),
                      },
                  icon: const Icon(Icons.add, color: Colors.white, size: 30),
                  label: Text(AppLocalizations.of(context)!.addMailbox,
                      style: Theme.of(context).textTheme.titleLarge!
                          .copyWith(color: Colors.white)),
                )
                : DropdownButton<String>(
                  value:
                      mailboxProvider.mailboxes.any(
                            (mailbox) =>
                                mailbox.id ==
                                mailboxProvider.selectedMailbox?.id,
                          )
                          ? mailboxProvider.selectedMailbox?.id
                          : null,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  elevation: 16,
                  style: Theme.of(context).textTheme.titleLarge!,
                  underline: Container(
                    height: 2,
                    color: CustomColors.primaryBlue,
                  ),
                  dropdownColor: CustomColors.secondaryBlue,
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
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                        );
                      }).toList(),
                );
          },
        ),
        buildNavItem(
          context: context,
          index: 0,
          icon: Icons.markunread_mailbox,
          label: AppLocalizations.of(context)!.home,
        ),
        buildNavItem(
          context: context,
          index: 1,
          icon: Icons.notifications,
          label: AppLocalizations.of(context)!.mail,
          trailing: Consumer<MailboxProvider>(
            builder: (context, mailboxProvider, child) {
              return mailboxProvider.unreadNotifications <= 0
                  ? const SizedBox.shrink()
                  : Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        mailboxProvider.unreadNotifications.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
            },
          ),
        ),
        buildNavItem(
          context: context,
          index: 2,
          icon: Icons.dialpad,
          label: AppLocalizations.of(context)!.keys,
        ),
        buildNavItem(
          context: context,
          index: 3,
          icon: Icons.nfc,
          label: AppLocalizations.of(context)!.packages,
        ),
        TextButton.icon(
          onPressed: () async {
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
            }
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.red, size: 30),
          label: Text(
            AppLocalizations.of(context)!.signout,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
      ],
    );
  }

  Widget buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    Widget? trailing,
  }) {
    final bool isSelected = selectedIndex == index;

    return TextButton.icon(
      onPressed: () => onItemTapped(index),
      icon: Stack(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFFD700) : Colors.white,
            size: 30,
          ),
          if (trailing != null) trailing,
        ],
      ),
      label: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isSelected ? const Color(0xFF1565C0) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
