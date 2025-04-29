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
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
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
  final PageController _pageController = PageController();

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    NotificationsTab(),
    AuthorizedKeysTab(key: ValueKey("keys_tab")),
    PackagesTab(key: ValueKey("packages_tab")),
  ];
  int _selectedIndex = 0;
  bool markNotificationsAsRead = false;

  void _onItemTapped(int index) {
    MailboxProvider mailboxProvider = Provider.of<MailboxProvider>(context, listen: false);
     if(index != 1 && markNotificationsAsRead) {
      NotificationService().markAllAsRead(
        mailboxProvider.selectedMailbox!.id,
      );
      setState(() {
        markNotificationsAsRead = false;
        _selectedIndex = index;
      });
    }
    else if(mailboxProvider.unreadNotifications > 0 && index == 1) {
      setState(() {
        markNotificationsAsRead = true;
        _selectedIndex = index;
      });
    }else{
      setState(() {
        _selectedIndex = index;
      });
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
   
  }

  Future<void> _signOut(BuildContext context) async {
    await _updateNotificationsPreferences(
      Provider.of<UserProvider>(context, listen: false).user!.uid,
    );
    await Provider.of<MailboxProvider>(context, listen: false).signOut();
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    
    await _authService.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthLoginScreen()),
      );
    }
  }
  Future<void> _updateNotificationsPreferences(String userId) async {
    List<String> mailboxes = await MailboxService().fetchUserMailboxKeysOnce(
      userId,
    );
    for (String mailboxId in mailboxes) {
      NotificationService().activateDeactivateMailboxNotifications(
        mailboxId,
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<MailboxProvider>(
          builder: (context, mailboxProvider, child) {
            if(mailboxProvider.unreadNotifications > 0 && _selectedIndex == 1) {
                markNotificationsAsRead = true;
            }
            return Text(
              mailboxProvider.selectedMailbox?.name ??
                  AppLocalizations.of(context)!.appTitle,
            );
          },
        ),
        iconTheme: const IconThemeData(color: CustomColors.unselectedItem),
      ),
      drawer: DrawerMenu(onSignOut: () => _signOut(context)),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
