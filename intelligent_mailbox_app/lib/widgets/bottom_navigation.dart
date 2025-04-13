import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.markunread_mailbox),
          label: AppLocalizations.of(context)!.home,
          backgroundColor: CustomColors.primaryBlue,
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.notifications),
              Consumer<MailboxProvider>(
                builder: (context, mailboxProvider, child) {
                  return mailboxProvider.unreadNotifications <= 0
                      ? SizedBox.shrink()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              mailboxProvider.unreadNotifications.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 8),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
          label: AppLocalizations.of(context)!.mail,
          backgroundColor: CustomColors.primaryBlue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dialpad),
          label: AppLocalizations.of(context)!.keys,
          backgroundColor: CustomColors.primaryBlue,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.nfc),
          label: AppLocalizations.of(context)!.packages,
          backgroundColor: CustomColors.primaryBlue,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: CustomColors.secondaryBlue,
      unselectedItemColor: CustomColors.unselectedItem,
      onTap: onItemTapped,
    );
  }
}
