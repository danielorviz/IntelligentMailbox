import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/pages/edit_auth_key.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class AuthorizedKeysTab extends StatelessWidget {
  const AuthorizedKeysTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: mailboxProvider.selectedMailbox?.authorizedKeys.length ?? 0,
        itemBuilder: (context, index) {
          final key = mailboxProvider.selectedMailbox?.authorizedKeys[index];
          final bool isExpired =
              false; // key['endDate'] != null && key['endDate'].isBefore(DateTime.now());

          return GestureDetector(
            onTap: () {
              // Navegar a la pantalla de edición
            },
            child: Card(
              color: isExpired ? Colors.red[100] : Colors.green[50],
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          key?.name ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          isExpired ? Icons.lock_open : Icons.lock,
                          color: isExpired ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 16),
                        const SizedBox(width: 8),
                        Text("Inicio: ${key?.initDate}"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 16),
                        const SizedBox(width: 8),
                        Text(key?.finishDate?.toString() ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditAuthKeyScreen()),
          );
        },
        backgroundColor: CustomColors.primaryBlue,
        child: const Icon(Icons.add, color: CustomColors.unselectedItem),
      ),
    );
  }
}
