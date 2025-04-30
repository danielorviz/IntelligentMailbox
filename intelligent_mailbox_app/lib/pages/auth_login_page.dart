import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/pages/auth_signup_page.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:intelligent_mailbox_app/widgets/responsive_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/pages/home_page.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/auth_service.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  AuthLoginScreenState createState() => AuthLoginScreenState();
}

class AuthLoginScreenState extends State<AuthLoginScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoadingPrincipal = false;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoadingPrincipal = true;
      });
      final user = await _authService.signInWithFirebase(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (user != null) {
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          _updateNotificationsPreferences(user.uid);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) =>
                      MyHomePage(title: AppLocalizations.of(context)!.appTitle),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context)!.welcome}, ${user.displayName ?? "Usuario"}!',
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.incorrectCredentials),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        String message = AppLocalizations.of(context)!.loginError;
        print(e.toString());
        if (e.toString().contains("email-not-verified")) {
          message = AppLocalizations.of(context)!.emailNotVerified;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      setState(() {
        _passwordController.clear();
        _isLoadingPrincipal = false;
      });
    }
  }

  Future<void> _updateNotificationsPreferences(String userId) async {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    List<String> mailboxes = await MailboxService().fetchUserMailboxKeysOnce(
      userId,
    );
    for (String mailboxId in mailboxes) {
      await prefs.loadPreferences(userId, mailboxId);
      NotificationService().activateDeactivateMailboxNotifications(
        mailboxId,
        prefs.isNotificationEnabled(userId, mailboxId),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailCannotBeEmpty;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }
    return null;
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    String? validEmail = _validateEmail(_emailController.text);
    if (validEmail != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.enterEmailToResetPassword,
          ),
        ),
      );
      return;
    }
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: AppLocalizations.of(context)!.passwordReset,
          content:
              "${AppLocalizations.of(context)!.passwordResetWillSent}: ${_emailController.text}",
          cancelText: AppLocalizations.of(context)!.cancel,
          confirmText: AppLocalizations.of(context)!.confirm,
        );
      },
    );

    if (confirm == true) {
      try {
        _authService.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.passwordResetEmailSent,
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordResetError),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ResponsiveWrapper(
              maxWidth: 500,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset('assets/images/logo1.png', height: 100),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          AppLocalizations.of(context)!.manageSmartMailboxes,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          return _validateEmail(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _signInWithEmailAndPassword(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AuthSignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.createAccount,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => _sendPasswordResetEmail(context),
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.copyright,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoadingPrincipal)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
