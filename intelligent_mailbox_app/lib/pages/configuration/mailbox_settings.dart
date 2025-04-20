import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:provider/provider.dart';

class MailboxSettingsScreen extends StatefulWidget {
  final Mailbox mailbox;
  const MailboxSettingsScreen({super.key, required this.mailbox});

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _notificationsEnabled = false;
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
      _notificationsEnabled = prefs.isNotificationEnabled(userProvider.user!.uid, mailboxId);
    });
  }

  void _saveSettings() async {
    if (_mailboxId == null) {
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
      await notificationService.activateDeactivateMailboxNotifications(_mailboxId!, _notificationsEnabled);
      await mailboxService.saveSettings(
        _mailboxId!,
        _nameController.text,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuración guardada exitosamente')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la configuración')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración del Buzón')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para el nombre del buzón
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Buzón',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Activar/desactivar notificaciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones Activadas',
                    style: TextStyle(fontSize: 16),
                  ),
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
              const SizedBox(height: 32),

              // Botón para guardar los cambios
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Guardar Configuración',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
