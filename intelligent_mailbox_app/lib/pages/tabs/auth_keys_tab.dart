import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/pages/edit_auth_key.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class AuthorizedKeysTab extends StatelessWidget {
  const AuthorizedKeysTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    final int offsetInSeconds =
        mailboxProvider.selectedMailbox?.instructions.offset ?? 0;

    if (mailbox == null) {
      return const Center(child: Text('No mailbox selected'));
    }

    return Scaffold(
  backgroundColor: Colors.white,
  body: CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final key = mailbox.authorizedKeys[index];
            final bool isExpired =
                key.permanent ? false : key.isExpired(offsetInSeconds);

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditAuthKeyScreen(
                      mailboxId: mailbox.id,
                      keyData: key,
                      offset: mailbox.instructions.offset,
                    ),
                  ),
                );
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
                            key.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                isExpired ? Icons.lock_open : Icons.lock,
                                color: isExpired ? Colors.red : Colors.green,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ConfirmationDialog(
                                        title: 'Confirmación',
                                        content:
                                            '¿Estás seguro de que deseas eliminar esta clave?',
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await MailboxService().deleteAuthorizedKey(
                                      mailbox.id,
                                      key.id,
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Clave eliminada con éxito',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (!key.permanent) ...{
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateTimeUtils.formatDate(
                                    key.getInitDateWithOffset(offsetInSeconds),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  DateTimeUtils.formatTime(
                                    key.getInitDateWithOffset(offsetInSeconds),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateTimeUtils.formatDate(
                                    key.getFinishDateWithOffset(offsetInSeconds),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  DateTimeUtils.formatTime(
                                    key.getFinishDateWithOffset(offsetInSeconds),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      } else ...{
                        Row(
                          children: [
                            const Icon(Icons.key, size: 16),
                            const SizedBox(width: 8),
                            const Text(
                              'Acceso permanente',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      },
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: mailbox.authorizedKeys.length,
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 80), // Ajuste dinámico
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditAuthKeyScreen(
            mailboxId: mailbox.id,
            offset: mailbox.instructions.offset,
          ),
        ),
      );
    },
    backgroundColor: CustomColors.primaryBlue,
    child: const Icon(Icons.add, color: CustomColors.unselectedItem),
  ),
);

  }
}
