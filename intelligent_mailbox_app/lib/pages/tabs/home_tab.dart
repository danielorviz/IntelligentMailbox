import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:intelligent_mailbox_app/pages/configuration/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:intelligent_mailbox_app/widgets/notifications_statistics.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  StreamSubscription<MailboxNotification?>? _streamSubscription;

  final MailboxService _mailboxService = MailboxService();
  final NotificationService _notificationsService = NotificationService();

  String lastKeyUsed = "";
  String lastPackageScanned = "";
  String lastCheckDate = "";
  bool checkingConnection = false;

  Future<void> checkConnection(String mailboxId) async {
    if (checkingConnection) return;
    setState(() {
      checkingConnection = true;
    });
    try {
      await _mailboxService.checkMailboxConnection(mailboxId);
    } finally {
      setState(() {
        checkingConnection = false;
      });
    }
  }

  void openMailbox() {
    // Lógica para abrir el buzón
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Buzón abierto")));
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    return Consumer<MailboxProvider>(
      builder: (context, mailboxProvider, child) {
        final mailbox = mailboxProvider.selectedMailbox;
        if (mailbox == null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noMailboxSelected),
          );
        }
        Provider.of<PreferencesProvider>(
          context,
          listen: false,
        ).loadPreferences(
          Provider.of<UserProvider>(context, listen: false).user!.uid,
          mailbox.id,
        );

        bool wifiStatus = mailbox.getWifiStatusBool();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message:
                                AppLocalizations.of(context)!.checkConnection,
                            child: IconButton(
                              icon: Icon(Icons.refresh, size: 20),
                              onPressed: () => checkConnection(mailbox.id),
                            ),
                          ),
                          Tooltip(
                            message:
                                AppLocalizations.of(context)!.mailboxConfig,
                            child: IconButton(
                              icon: Icon(Icons.settings, size: 20),
                              onPressed:
                                  () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const MailboxSettingsScreen(),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Icon(Icons.markunread_mailbox, size: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.mailboxStatus,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  if (checkingConnection) ...{
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.checkingConnection,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.orange),
                                    ),
                                  } else ...{
                                    Icon(
                                      wifiStatus ? Icons.wifi : Icons.wifi_off,
                                      color:
                                          wifiStatus
                                              ? Colors.green
                                              : Colors.red,
                                      size: 20,
                                    ),
                                    Text(
                                      wifiStatus
                                          ? AppLocalizations.of(
                                            context,
                                          )!.connected
                                          : AppLocalizations.of(
                                            context,
                                          )!.disconnected,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            wifiStatus
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  },
                                ],
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.access_time, size: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.lastCheck,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                        ),
                                        TextSpan(
                                          text:
                                              checkingConnection
                                                  ? AppLocalizations.of(
                                                    context,
                                                  )!.checking
                                                  : '${DateTimeUtils.formatDate(mailbox.getLastWifiStatusCheckWithOffset())} ${DateTimeUtils.formatTime(mailbox.getLastWifiStatusCheckWithOffset())}',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Consumer<PreferencesProvider>(
                                builder: (context, preferences, child) {
                                  return Row(
                                    spacing: 8,
                                    children: [
                                      Icon(
                                        preferences.notificationsEnabled
                                            ? Icons.notifications_active
                                            : Icons.notifications_off,
                                        size: 20,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${AppLocalizations.of(context)!.notifications}: ',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelLarge,
                                            ),
                                            TextSpan(
                                              text:
                                                  preferences
                                                          .notificationsEnabled
                                                      ? AppLocalizations.of(
                                                        context,
                                                      )!.active
                                                      : AppLocalizations.of(
                                                        context,
                                                      )!.inactive,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color:
                                                    preferences
                                                            .notificationsEnabled
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.public, size: 20),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${AppLocalizations.of(context)!.timezone}: ',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                        ),
                                        TextSpan(
                                          text:
                                              DateTimeUtils.getOffsetStringLabel(
                                                context,
                                                mailbox.instructions.offset,
                                              ),
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Icon(Icons.dialpad, size: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.lastKeyboardAccess,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              ..._buildLastAccess(
                                mailbox.id,
                                AppLocalizations.of(context)!.keyName,
                                MailboxNotification.typeKey,
                                mailbox.instructions.offset,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Icon(Icons.nfc, size: 25),
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.lastScanAccess,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              ..._buildLastAccess(
                                mailbox.id,
                                AppLocalizations.of(context)!.packageCode,
                                MailboxNotification.typePackage,
                                mailbox.instructions.offset,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Icon(Icons.notifications, size: 25),
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.lastNotificationReceived,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              ..._buildLastAccess(
                                mailbox.id,
                                AppLocalizations.of(context)!.info,
                                null,
                                mailbox.instructions.offset,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              NotificationsStatistics(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildLastAccess(
    String mailboxId,
    String infoLabel,
    String? type,
    int timezoneOffset,
  ) {
    return [
      StreamBuilder<MailboxNotification?>(
        stream: _notificationsService.getLastNotificationByType(
          mailboxId,
          type,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text(
              AppLocalizations.of(context)!.noRecentInfo,
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          final notification = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$infoLabel: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextSpan(
                      text:
                          type != null
                              ? notification.typeInfo
                              : notification.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.date}: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextSpan(
                      text:
                          '${DateTimeUtils.formatDate(notification.getTimeWithOffset(timezoneOffset))} ${DateTimeUtils.formatTime(notification.getTimeWithOffset(timezoneOffset))}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}
