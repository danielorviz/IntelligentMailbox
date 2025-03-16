import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';

class EditPackageScreen extends StatefulWidget {
  final AuthorizedPackage? keyData;
  final String mailboxId;

  const EditPackageScreen({super.key, this.keyData, required this.mailboxId});

  @override
  State<EditPackageScreen> createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen> {
  final MailboxService _mailboxService = MailboxService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  bool _isPermanent = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.keyData?.name ?? '');
    _valueController = TextEditingController(text: widget.keyData?.value ?? '');
    _isPermanent = widget.keyData?.permanent ?? false;
  }

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      if (widget.keyData != null) {
        final updatedKey = AuthorizedPackage(
          permanent: _isPermanent,
          name: _nameController.text,
          value: _valueController.text,
          id: widget.keyData!.id,
        );
        await _mailboxService.updateAuthorizedPackage(
          widget.mailboxId,
          updatedKey,
        );
      } else {
        final newKey = AuthorizedPackage(
          permanent: _isPermanent,
          name: _nameController.text,
          value: _valueController.text,
          id: "newKey",
        );
        await _mailboxService.createAuthorizedPackage(widget.mailboxId, newKey);
      }
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.successfullyUpdated),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.keyData != null
                ? Text(AppLocalizations.of(context)!.editPackage)
                : Text(AppLocalizations.of(context)!.newPackage),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.packageCode,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterPackageCode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.packageCode,
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
                    return AppLocalizations.of(context)!.enterPackageCode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.permanentAccess,
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveKey,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.save,
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
