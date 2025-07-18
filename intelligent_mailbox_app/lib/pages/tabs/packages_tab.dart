import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/pages/edit_package.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/app_theme.dart';
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
import 'package:intelligent_mailbox_app/widgets/custom_floating_button.dart';
import 'package:provider/provider.dart';

class PackagesTab extends StatelessWidget {
  const PackagesTab({super.key});

  Color _getCardColor(bool isKey, bool received) {
    return isKey
        ? Colors.white
        : received
        ? AppTheme.cardActiveLight
        : Colors.yellow.shade50;
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;
    if (mailbox == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noMailboxSelected,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    if (mailbox.authorizedPackages.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.haveNoPackages,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          pageBuilder: (context) => EditPackageScreen(mailboxId: mailbox.id),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (kIsWeb) ...[
            SliverAppBar(
              floating: false,
              elevation: 0,
              flexibleSpace: Container(color: AppTheme.scaffoldBackgroundColor),
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white,),
                    label: Text(AppLocalizations.of(context)!.newPackage),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditPackageScreen(mailboxId: mailbox.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final key = mailbox.authorizedPackages[index];

              return GestureDetector(
                onTap: () {
                  if (key.received && !key.isKey) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.packageAlreadyReceived,
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => EditPackageScreen(
                            mailboxId: mailbox.id,
                            keyData: key,
                          ),
                    ),
                  );
                },
                child: Card(
                  color: _getCardColor(key.isKey, key.received),
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
                                  key.isKey
                                      ? Icons.key:
                                      key.received
                                          ? Icons.check_outlined
                                      : Icons.local_shipping,
                                  size: 25,
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
                                                  )!.confirmDeleteAuthPackage,
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
                                          .deleteAuthorizedPackage(
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
                                              )!.authPackageDeleted,
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
                        if (key.isKey) ...{
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.permanentKey,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        } else ...{
                          Row(
                            children: [
                              Text(
                                key.received
                                    ? AppLocalizations.of(context)!.received
                                    : AppLocalizations.of(context)!.pending,
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
            }, childCount: mailbox.authorizedPackages.length),
          ),
          SliverPadding(padding: const EdgeInsets.only(bottom: 80)),
        ],
      ),
      floatingActionButton: kIsWeb? null: CustomFloatingActionButton(
        pageBuilder: (context) => EditPackageScreen(mailboxId: mailbox.id),
      ),
    );
  }
}
