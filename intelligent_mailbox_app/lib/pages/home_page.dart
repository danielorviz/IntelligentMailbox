import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelligent_mailbox_app/pages/login_page.dart';
import 'package:intelligent_mailbox_app/pages/mailbox_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/home_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/notifications_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/profile_tab.dart';
import 'package:intelligent_mailbox_app/pages/tabs/settings_tab.dart';
import 'package:intelligent_mailbox_app/widgets/drawer_menu.dart';
import 'package:intelligent_mailbox_app/widgets/mailbox_selector.dart';
import 'package:intelligent_mailbox_app/widgets/bottom_navigation.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedMailbox = 'Buzón 1';
  final List<String> _mailboxes = ['Buzón 1', 'Buzón 2', 'Buzón 3'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: DrawerMenu(onSignOut: () => _signOut(context),mailboxes: _mailboxes,selectedMailbox: _selectedMailbox,),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          HomeTab(),
          MailboxTab(),
          NotificationsTab(),
          SettingsTab(),
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