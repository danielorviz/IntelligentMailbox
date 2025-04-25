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
import 'package:intelligent_mailbox_app/widgets/confirm_dialog.dart';
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
  bool isOpening = false;

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

  Future<void> openMailbox(String mailboxId) async {
    setState(() {
      isOpening = true;
    });
    try {
      MailboxService().openDoor(mailboxId);
      await Future.delayed(Duration(seconds: 5));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.instructionSent),
          ),
        );
      }
    } finally {
      setState(() {
        isOpening = false;
      });
    }
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
        final userUid =
            Provider.of<UserProvider>(context, listen: false).user!.uid;
        Provider.of<PreferencesProvider>(
          context,
          listen: false,
        ).loadPreferences(userUid, mailbox.id);

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
                                          (context) => MailboxSettingsScreen(
                                            mailbox: mailbox,
                                          ),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.markunread_mailbox, size: 25),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.mailboxStatus,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  softWrap: true,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (checkingConnection) ...{
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.checkingConnection,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.orange),
                                          softWrap: true,
                                        ),
                                      ),
                                    } else ...{
                                      Icon(
                                        wifiStatus
                                            ? Icons.wifi
                                            : Icons.wifi_off,
                                        color:
                                            wifiStatus
                                                ? Colors.green
                                                : Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
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
                                          softWrap: true,
                                        ),
                                      ),
                                    },
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text.rich(
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
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Consumer<PreferencesProvider>(
                                  builder: (context, preferences, child) {
                                    return Row(
                                      children: [
                                        Icon(
                                          preferences.isNotificationEnabled(
                                                userUid,
                                                mailbox.id,
                                              )
                                              ? Icons.notifications_active
                                              : Icons.notifications_off,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text.rich(
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
                                                              .isNotificationEnabled(
                                                                userUid,
                                                                mailbox.id,
                                                              )
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
                                                                .isNotificationEnabled(
                                                                  userUid,
                                                                  mailbox.id,
                                                                )
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.door_front_door_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' ${AppLocalizations.of(context)!.door}: ',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelLarge,
                                            ),
                                            TextSpan(
                                              text:
                                                  mailbox.getDoorStatusBool()
                                                      ? AppLocalizations.of(
                                                        context,
                                                      )!.opened
                                                      : AppLocalizations.of(
                                                        context,
                                                      )!.closed,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                color:
                                                    mailbox.getDoorStatusBool()
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        if (isOpening || mailbox.getDoorStatusBool()) return;
                                        final bool? confirm =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmationDialog(
                                                  title:
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.openDoor,
                                                  content:
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.confirmOpenDoor,
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
                                          openMailbox(mailbox.id);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.lock_open,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        AppLocalizations.of(context)!.openDoor,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.dialpad, size: 25),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.lastKeyboardAccess,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  softWrap: true,
                                ),
                                ..._buildLastAccess(
                                  mailbox.id,
                                  AppLocalizations.of(context)!.keyName,
                                  MailboxNotification.typeKey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // Espaciado entre filas
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.nfc, size: 25),
                          SizedBox(width: 16), // Espaciado entre Icon y Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.lastScanAccess,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  softWrap: true,
                                ),
                                ..._buildLastAccess(
                                  mailbox.id,
                                  AppLocalizations.of(context)!.packageCode,
                                  MailboxNotification.typePackage,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications, size: 25),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.lastNotificationReceived,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  softWrap: true,
                                ),
                                ..._buildLastAccess(
                                  mailbox.id,
                                  AppLocalizations.of(context)!.info,
                                  null,
                                ),
                              ],
                            ),
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

  List<Widget> _buildLastAccess(String mailboxId, String infoLabel, int? type) {
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
              softWrap: true,
            );
          }

          final notification = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                softWrap: true,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$infoLabel: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextSpan(
                      text:
                          type != null
                              ? notification.getTypeInfoName()
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
                          '${DateTimeUtils.formatDate(notification.getTimeWithOffset())} ${DateTimeUtils.formatTime(notification.getTimeWithOffset())}',
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
