import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/services/auth_service.dart';

class AuthSignupScreen extends StatefulWidget {
  const AuthSignupScreen({super.key});

  @override
  AuthSignupScreenState createState() => AuthSignupScreenState();
}

class AuthSignupScreenState extends State<AuthSignupScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoadingPrincipal = false;

  Future<void> _signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoadingPrincipal = true;
      });
      final user = await _authService.registerWithFirebase(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (user != null) {
        if(context.mounted){
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.signupSuccess)),
        );}
      }
    } on Exception catch (e) {
      if (context.mounted) {
        String codigo = e.toString();
        String mensaje = AppLocalizations.of(context)!.unexpectedError;
        if (codigo.contains('user-not-found')) {
          mensaje = AppLocalizations.of(context)!.userNotFound;
        } else if (codigo.contains('email-already-in-use')) {
          mensaje = AppLocalizations.of(context)!.emailAlreadyInUse;
        } else if (codigo.contains('invalid-email')) {
          mensaje = AppLocalizations.of(context)!.invalidEmail;
        } else if (codigo.contains('weak-password')) {
          mensaje = AppLocalizations.of(context)!.weakPassword;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
      }
    } finally {
      setState(() {
        isLoadingPrincipal = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAccount),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Reemplaza con la ruta de tu imagen
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 50,
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
                        return _validateEmail(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 20,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(
                            context,
                          )!.nameCannotBeEmpty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        prefixIcon: const Icon(Icons.lock),
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
                        if (value.length < 6) {
                          return AppLocalizations.of(context)!.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.confirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return AppLocalizations.of(context)!.passwordMismatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => _signUp(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.signup,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.alreadyHaveAccount,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoadingPrincipal)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
