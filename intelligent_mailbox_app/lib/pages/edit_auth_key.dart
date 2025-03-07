import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class EditAuthKeyScreen extends StatefulWidget {
  final AuthorizedKey? keyData;
  final String mailboxId;
  final int offset;

  const EditAuthKeyScreen({super.key, this.keyData, required this.mailboxId, required this.offset});

  @override
  State<EditAuthKeyScreen> createState() => _EditKeyScreenState();
}

class _EditKeyScreenState extends State<EditAuthKeyScreen> {
  final MailboxService _mailboxService = MailboxService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  DateTime? _initDate;
  DateTime? _finishDate;
  bool _isPermanent = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.keyData?.name ?? '');
    _valueController = TextEditingController(text: widget.keyData?.value ?? '');
    _initDate = widget.keyData?.getInitDateWithOffset(widget.offset);
    _finishDate = widget.keyData?.getFinishDateWithOffset(widget.offset);
    _isPermanent = widget.keyData?.permanent ?? false;
  }

  Future<void> _selectStartDate(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _initDate ?? now,
    firstDate: _initDate ?? now,
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    if (context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_initDate ?? now),
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
          _initDate = combinedDateTime;
          _finishDate = null; // Resetear la fecha de finalización
        });
      }
    }
  }
}

Future<void> _selectEndDate(BuildContext context) async {
  if (_initDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debe seleccionar una fecha de inicio primero'),
      ),
    );
    return;
  }

  final DateTime now = DateTime.now();
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _finishDate ?? (_initDate!.isAfter(now) ? _initDate! : now),
    firstDate: _initDate!,
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    if (context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_finishDate ?? now),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.isAfter(_initDate!)) {
          setState(() {
            _finishDate = combinedDateTime;
          });
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
    }
  }
}


  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      if (!_isPermanent && (_initDate == null || _finishDate == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las fechas de inicio y finalización son obligatorias'),
          ),
        );
        return;
      }
      if(widget.keyData != null) {
        final updatedKey = AuthorizedKey(
          initDate: DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(_initDate),
          permanent: _isPermanent,
          name: _nameController.text,
          value: _valueController.text,
          id: widget.keyData!.id,
          finishDate: DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(_finishDate),
        );
        await _mailboxService.updateAuthorizedKey(widget.mailboxId, updatedKey);
        print('Actualizado: ${updatedKey.toMap()}');
      }else{
          final newKey = AuthorizedKey(
          initDate: DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(_initDate),
          permanent: _isPermanent,
          name: _nameController.text,
          value: _valueController.text,
          id: "newKey",
          finishDate: DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(_finishDate),
        );
        await _mailboxService.createAuthorizedKey(widget.mailboxId, newKey);
        print('Guardado: ${newKey.toMap()}');
      }
      if(mounted){
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Actualizado correctamente'),
            ),
          );
      }
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
              obscureText: _isObscured,
              decoration: InputDecoration(
              labelText: 'Contraseña',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
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
                trailing: const Icon(Icons.calendar_month),
                onTap: () => _selectStartDate(context),
              ),
              ListTile(
                title: const Text('Fecha de Finalización'),
                subtitle: Text(
                  _finishDate != null
                      ? _finishDate!.toLocal().toString()
                      : 'Seleccione una fecha',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _initDate == null
                    ? null
                    : () => _selectEndDate(context),
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