import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/pages/home_page.dart';
import 'package:intelligent_mailbox_app/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, MailboxProvider>(
          create: (context) => MailboxProvider(Provider.of<UserProvider>(context, listen: false)),
          update: (context, userProvider, mailboxProvider) => MailboxProvider(userProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Intelligent Mailbox',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
 Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<UserProvider>(context, listen: false).setUser(snapshot.data);
          });
          return const MyHomePage(title: "Intelligent Mailbox");
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}