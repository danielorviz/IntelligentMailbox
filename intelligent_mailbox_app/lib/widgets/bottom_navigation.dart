import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';

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
          icon: Icon(Icons.mail),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: CustomColors.primaryBlue,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: CustomColors.secondaryBlue,
      unselectedItemColor:  CustomColors.unselectedItem,
      onTap: onItemTapped,
    );
  }
}