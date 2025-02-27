import 'package:flutter/material.dart';

class MailboxTab extends StatelessWidget {
  const MailboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('Mailbox Tab'),
        ],
      ),
    );
  }
}