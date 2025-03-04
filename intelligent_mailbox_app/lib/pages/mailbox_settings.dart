import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailboxSettingsScreen extends StatefulWidget {
  const MailboxSettingsScreen({super.key});

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _notificationsEnabled = false;
  String _selectedOffset = 'system'; // El valor por defecto será "system"

  final List<Map<String, dynamic>> _offsetOptions = [
    {'label': 'Usar el offset del sistema', 'value': 'system'},
    {'label': 'UTC-12:00', 'value': -43200},
    {'label': 'UTC-11:00', 'value': -39600},
    {'label': 'UTC-10:00', 'value': -36000},
    {'label': 'UTC-09:00', 'value': -32400},
    {'label': 'UTC-08:00', 'value': -28800},
    {'label': 'UTC-07:00', 'value': -25200},
    {'label': 'UTC-06:00', 'value': -21600},
    {'label': 'UTC-05:00', 'value': -18000},
    {'label': 'UTC-04:00', 'value': -14400},
    {'label': 'UTC-03:00', 'value': -10800},
    {'label': 'UTC-02:00', 'value': -7200},
    {'label': 'UTC-01:00', 'value': -3600},
    {'label': 'UTC+00:00', 'value': 0},
    {'label': 'UTC+01:00', 'value': 3600},
    {'label': 'UTC+02:00', 'value': 7200},
    {'label': 'UTC+03:00', 'value': 10800},
    {'label': 'UTC+04:00', 'value': 14400},
    {'label': 'UTC+05:00', 'value': 18000},
    {'label': 'UTC+06:00', 'value': 21600},
    {'label': 'UTC+07:00', 'value': 25200},
    {'label': 'UTC+08:00', 'value': 28800},
    {'label': 'UTC+09:00', 'value': 32400},
    {'label': 'UTC+10:00', 'value': 36000},
    {'label': 'UTC+11:00', 'value': 39600},
    {'label': 'UTC+12:00', 'value': 43200},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('mailboxName') ?? '';
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _selectedOffset = prefs.getString('timeOffset') ?? 'system';
    });
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mailboxName', _nameController.text);
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setString('timeOffset', _getOffset().toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración guardada exitosamente')),
    );
  }

  int _getOffset() {
  if (_selectedOffset == 'system') {
    return DateTime.now().timeZoneOffset.inSeconds;
  } else {
    final offset = _offsetOptions.firstWhere(
      (offset) => offset['value'].toString() == _selectedOffset,
      orElse: () => {'value': 0}, 
    );
    return offset['value'];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Buzón'),
        backgroundColor: Colors.blue,
      ),
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
                items: _offsetOptions.map<DropdownMenuItem<String>>((Map<String, dynamic> offset) {
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
                  backgroundColor: Colors.blue,
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
