import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/pages/login_page.dart';
import 'package:intelligent_mailbox_app/pages/tabs/auth_keys_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/home_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/notifications_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/profile_tab.dart';
import 'package:intelligent_mailbox_app/pages/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/auth_service.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:intelligent_mailbox_app/widgets/drawer_menu.dart';
import 'package:intelligent_mailbox_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    if (context.mounted) {
      Provider.of<UserProvider>(context, listen: false).setUser(null);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text(mailboxProvider.selectedMailbox?.name ??
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(color: CustomColors.unselectedItem, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: CustomColors.unselectedItem),
      ),
      drawer: DrawerMenu(onSignOut: () => _signOut(context)),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          HomeTab(),
          NotificationsTab(),
          AuthorizedKeysTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
