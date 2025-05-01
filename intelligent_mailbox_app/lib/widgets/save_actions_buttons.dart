import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';

class SaveActionsButtons extends StatelessWidget {
  final VoidCallback onSave;
  final String saveText;

  const SaveActionsButtons({
    Key? key,
    required this.onSave,
    required this.saveText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(saveText),
            ),
          ],
        )
        : ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(saveText),
        );
  }
}
