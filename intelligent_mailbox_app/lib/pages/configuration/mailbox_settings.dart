import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/utils/constants.dart';
import 'package:provider/provider.dart';

class MailboxSettingsScreen extends StatefulWidget {
  final Mailbox mailbox;
  const MailboxSettingsScreen({super.key, required this.mailbox});

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _notificationsEnabled = false;
  String _selectedLanguage = Constants.languageDefault;
  final MailboxService mailboxService = MailboxService();
  final NotificationService notificationService = NotificationService();
  String? _mailboxId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSettings();
    });
  }

  Future<void> _initializeSettings() async {
    if (mounted) {
      setState(() {
        _nameController.text = widget.mailbox.name;
        _selectedLanguage = widget.mailbox.language;
      });
      _mailboxId = widget.mailbox.id;
      await _loadPreferences(widget.mailbox.id);
    }
  }

  Future<void> _loadPreferences(String mailboxId) async {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await prefs.loadPreferences(userProvider.user!.uid, mailboxId);
    setState(() {
      _notificationsEnabled = prefs.isNotificationEnabled(
        userProvider.user!.uid,
        mailboxId,
      );
    });
  }

  void _saveSettings() async {
    if (_mailboxId == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    prefs.updateNotificationState(
      userProvider.user!.uid,
      _mailboxId!,
      _notificationsEnabled,
    );

    try {
      await notificationService.activateDeactivateMailboxNotifications(
        _mailboxId!,
        _notificationsEnabled,
      );
      await mailboxService.saveSettings(
        _mailboxId!,
        _nameController.text,
        _selectedLanguage,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsSavedSuccess),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsSavedError),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mailboxSettingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.mailboxNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 10,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.mailboxNameHint
                              : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.notificationsEnabledLabel,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 24),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.notificationLanguageLabel,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 24),
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      items:
                          Constants.supportedLanguages.map((language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.language(language),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.saveSettingsButton,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
