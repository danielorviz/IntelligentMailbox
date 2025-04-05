import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailboxSettingsScreen extends StatefulWidget {
  const MailboxSettingsScreen({super.key});

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _notificationsEnabled = false;
  final MailboxService mailboxService = MailboxService();
  String _selectedOffset = '0'; // El valor por defecto será "system"
  String? _mailboxId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSettings();
    });
  }

  Future<void> _initializeSettings() async {
    final mailboxProvider = Provider.of<MailboxProvider>(
      context,
      listen: false,
    );
    final mailbox = mailboxProvider.selectedMailbox;

    if (mailbox != null) {
      if (mounted) {
        setState(() {
          _nameController.text = mailbox.name;
          _selectedOffset =
              DateTimeUtils.getOffsetStringValue(context, mailbox.instructions.offset);
        });
      }
      _mailboxId = mailbox.id;
      await _loadPreferences(mailbox.id);
    }
  }

  Future<void> _loadPreferences(String mailboxId) async {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    await prefs.loadPreferences(mailboxId);
    setState(() {
      _notificationsEnabled = prefs.notificationsEnabled;
    });
  }

  void _saveSettings() async {
    if (_mailboxId == null) {
      return;
    }
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    prefs.updateNotificationState(_mailboxId!, _notificationsEnabled);

    try {
      await mailboxService.saveSettings(
        _mailboxId!,
        _nameController.text,
        _getOffset(),
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

  int _getOffset() {
    if (_selectedOffset == 'system') {
      return DateTime.now().timeZoneOffset.inSeconds;
    } else {
      final offset = DateTimeUtils.getOffsetOptions(context).firstWhere(
        (offset) => offset['value'].toString() == _selectedOffset,
        orElse: () => {'value': 0},
      );
      return offset['value'];
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
              const SizedBox(height: 16),

              // Dropdown para seleccionar el time offset
              DropdownButtonFormField<String>(
                value: _selectedOffset,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Time Offset',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOffset = newValue!;
                  });
                },
                items:
                    DateTimeUtils.getOffsetOptions(context).map<DropdownMenuItem<String>>((
                      Map<String, dynamic> offset,
                    ) {
                      return DropdownMenuItem<String>(
                        value: offset['value'].toString(),
                        child: Text(offset['label']),
                      );
                    }).toList(),
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
