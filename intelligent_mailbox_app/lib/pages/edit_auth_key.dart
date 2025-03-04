import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';

class EditAuthKeyScreen extends StatefulWidget {
  final AuthorizedKey? keyData;

  const EditAuthKeyScreen({super.key, this.keyData});

  @override
  State<EditAuthKeyScreen> createState() => _EditKeyScreenState();
}

class _EditKeyScreenState extends State<EditAuthKeyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  DateTime? _initDate;
  DateTime? _finishDate;
  bool _isPermanent = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.keyData?.name ?? '');
    _valueController = TextEditingController(text: widget.keyData?.value ?? '');
    _initDate =
        widget.keyData != null
            ? DateTime.fromMillisecondsSinceEpoch(
              widget.keyData!.initDate * 1000,
            )
            : null;
    _finishDate =
        widget.keyData != null
            ? DateTime.fromMillisecondsSinceEpoch(
              widget.keyData!.finishDate * 1000,
            )
            : null;
    _isPermanent = widget.keyData?.permanent ?? false;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate
              ? (_initDate ?? now)
              : (_finishDate ??
                  (now.isAfter(_initDate ?? now) ? now : _initDate!)),
      firstDate: isStartDate ? now : (_initDate ?? now),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            isStartDate ? (_initDate ?? now) : (_finishDate ?? now),
          ),
        );
        if (pickedTime != null) {
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          setState(() {
            if (isStartDate) {
              _initDate = combinedDateTime;
              if (_finishDate != null && _finishDate!.isBefore(_initDate!)) {
                _finishDate = null;
              }
            } else {
              if (combinedDateTime.isAfter(_initDate!)) {
                _finishDate = combinedDateTime;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La fecha de finalización debe ser posterior a la de inicio',
                    ),
                  ),
                );
              }
            }
          });
        }
      }
    }
  }

  void _saveKey() {
    if (_formKey.currentState!.validate()) {
      final newKey = AuthorizedKey(
        initDate: _initDate?.millisecondsSinceEpoch ?? 0,
        permanent: _isPermanent,
        name: _nameController.text,
        value: _valueController.text,
        id: "newKey",
        finishDate: _finishDate?.millisecondsSinceEpoch ?? 0,
      );

      print('Guardado: ${newKey.toMap()}');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Clave"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Clave',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor de la Clave',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Clave Permanente',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _isPermanent,
                    onChanged: (value) {
                      setState(() {
                        _isPermanent = value;
                      });
                    },
                  ),
                ],
              ),
              if (!_isPermanent) ...[
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Fecha de Inicio'),
                  subtitle: Text(
                    _initDate != null
                        ? _initDate!.toLocal().toString()
                        : 'Seleccione una fecha',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                ListTile(
                  title: const Text('Fecha de Finalización'),
                  subtitle: Text(
                    _finishDate != null
                        ? _finishDate!.toLocal().toString()
                        : 'Seleccione una fecha',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveKey,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Guardar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
