import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/pages/auth_login_page.dart';
import 'package:intelligent_mailbox_app/pages/tabs/auth_keys_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/home_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/notifications_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/packages_tab.dart';
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
  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
          NotificationsTab(),
          AuthorizedKeysTab(key: ValueKey("keys_tab")),
          PackagesTab(key: ValueKey("packages_tab")),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    Provider.of<MailboxProvider>(context, listen: false).signOut();
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    await _authService.signOut();
    if (context.mounted) {
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(mailboxProvider.selectedMailbox?.name ??
          AppLocalizations.of(context)!.appTitle,
        ),
        iconTheme: const IconThemeData(color: CustomColors.unselectedItem),
      ),
      drawer: DrawerMenu(onSignOut: () => _signOut(context)),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
