import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/pages/edit_auth_key.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
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
    if(!context.mounted) return const SizedBox.shrink();
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (mailbox == null || user == null) {
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
                userId: user.uid,
                mailboxId: mailbox.id,
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
                  key.permanent ? false : key.isExpired();
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => EditAuthKeyScreen(
                            userId: user.uid,
                            mailboxId: mailbox.id,
                            keyData: key,
                          ),
                    ),
                  );
                },
                child: Card(
                  color:key.permanent? Colors.white:
                      isExpired
                          ? (
                              AppTheme.cardExpiredLight)
                          : (
                               AppTheme.cardActiveLight),
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
                                  key.permanent? Icons.key:
                                  isExpired ? Icons.timer_off_sharp : Icons.timer_sharp,
                                  color:key.permanent? Colors.black: isExpired ? Colors.red : Colors.green,
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
                                              cancelText:
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.cancel,
                                              confirmText:
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.confirm,
                                            );
                                          },
                                        );

                                    if (confirm == true) {
                                      await MailboxService()
                                          .deleteAuthorizedKey(
                                            user.uid,
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
                                  const Icon(Icons.event, size: 18),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateTimeUtils.formatDate(
                                          key.getInitDateWithOffset(
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
                                  const Icon(Icons.event_available, size: 18),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateTimeUtils.formatDate(
                                          key.getFinishDateWithOffset(
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
              userId: user.uid,
              mailboxId: mailbox.id,
            ),
      ),
    );
  }
}
