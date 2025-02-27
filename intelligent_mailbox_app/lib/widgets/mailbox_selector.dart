import 'package:flutter/material.dart';

class MailboxSelector extends StatelessWidget {
  final String selectedMailbox;
  final List<String> mailboxes;
  final ValueChanged<String?> onChanged;

  const MailboxSelector({
    super.key,
    required this.selectedMailbox,
    required this.mailboxes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMailbox,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: onChanged,
      items: mailboxes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}