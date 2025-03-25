import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/pages/edit_auth_key.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/app_theme.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:intelligent_mailbox_app/widgets/custom_floating_button.dart';
import 'package:provider/provider.dart';

class AuthorizedKeysTab extends StatelessWidget {
  const AuthorizedKeysTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    final int offsetInSeconds =
        mailboxProvider.selectedMailbox?.instructions.offset ?? 0;

    if (mailbox == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noMailboxSelected,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    if (mailbox.authorizedKeys.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.haveNoAuthKeys,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          pageBuilder:
              (context) => EditAuthKeyScreen(
                mailboxId: mailbox.id,
                offset: mailbox.instructions.offset,
              ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final key = mailbox.authorizedKeys[index];
              final bool isExpired =
                  key.permanent ? false : key.isExpired(offsetInSeconds);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => EditAuthKeyScreen(
                            mailboxId: mailbox.id,
                            keyData: key,
                            offset: mailbox.instructions.offset,
                          ),
                    ),
                  );
                },
                child: Card(
                  color:
                      isExpired
                          ? (isDarkTheme
                              ? AppTheme.cardExpiredDark
                              : AppTheme.cardExpiredLight)
                          : (isDarkTheme
                              ? AppTheme.cardActiveDark
                              : AppTheme.cardActiveLight),
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
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final bool? confirm =
                                        await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConfirmationDialog(
                                              title:
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.delete,
                                              content:
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.confirmDeleteAuthKey,
                                            );
                                          },
                                        );

                                    if (confirm == true) {
                                      await MailboxService()
                                          .deleteAuthorizedKey(
                                            mailbox.id,
                                            key.id,
                                          );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.authKeyDeleted,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.date_range, size: 18),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateTimeUtils.formatDate(
                                          key.getInitDateWithOffset(
                                            offsetInSeconds,
                                          ),
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        DateTimeUtils.formatTime(
                                          key.getInitDateWithOffset(
                                            offsetInSeconds,
                                          ),
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.date_range, size: 18),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateTimeUtils.formatDate(
                                          key.getFinishDateWithOffset(
                                            offsetInSeconds,
                                          ),
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        DateTimeUtils.formatTime(
                                          key.getFinishDateWithOffset(
                                            offsetInSeconds,
                                          ),
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),
                        } else ...{
                          Row(
                            children: [
                              const Icon(Icons.key, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.permanentKey,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: mailbox.authorizedKeys.length),
          ),
          SliverPadding(padding: const EdgeInsets.only(bottom: 80)),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        pageBuilder:
            (context) => EditAuthKeyScreen(
              mailboxId: mailbox.id,
              offset: mailbox.instructions.offset,
            ),
      ),
    );
  }
}
