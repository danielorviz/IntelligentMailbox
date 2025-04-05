import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/generated/l10n.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:intelligent_mailbox_app/pages/configuration/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/providers/preferences_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/widgets/notifications_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  StreamSubscription<MailboxNotification?>? _streamSubscription;

  final MailboxService _mailboxService = MailboxService();
  bool isConnected = false;
  String lastKeyUsed = "1234";
  String lastPackageScanned = "Paquete #5678";
  String lastCheckDate = "Nunca";

  void checkConnection() {
    setState(() {
      isConnected = !isConnected;
    });
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

    final dates = [
      DateTime(2022, 9, 19),
      DateTime(2022, 9, 26),
      DateTime(2022, 10, 3),
      DateTime(2022, 10, 10),
    ];
    final counts = [5, 25, 100, 75];

    return Consumer<MailboxProvider>(
      builder: (context, mailboxProvider, child) {
        final mailbox = mailboxProvider.selectedMailbox;
        if (mailbox == null) {
          return const Center(child: Text('No mailbox selected'));
        }
        Provider.of<PreferencesProvider>(
          context,
          listen: false,
        ).loadPreferences(mailbox.id);

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
                          IconButton(
                            icon: Icon(Icons.refresh, size: 20),
                            onPressed: checkConnection,
                          ),
                          IconButton(
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
                        ],
                      ),
                      Row(
                        spacing: 16,
                        children: [
                          Icon(
                            isConnected ? Icons.wifi : Icons.wifi_off,
                            color: isConnected ? Colors.green : Colors.red,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Estado del Buzón",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                isConnected ? "Conectado" : "Desconectado",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color:
                                      isConnected ? Colors.green : Colors.red,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Última comprobación: ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                    ),
                                    TextSpan(
                                      text: lastCheckDate,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Consumer<PreferencesProvider>(
                                builder: (context, preferences, child) {
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Notificaciones: ",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                        ),
                                        TextSpan(
                                          text:
                                              preferences.notificationsEnabled
                                                  ? "Activadas"
                                                  : "Desactivadas",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                preferences.notificationsEnabled
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Zona horaria: ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                    ),
                                    TextSpan(
                                      text: DateTimeUtils.getOffsetStringLabel(
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
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              Icon(Icons.dialpad, size: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text(
                                    "Último acceso por clave",
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                  ..._buildLastAccess(
                                    mailbox.id,
                                    AppLocalizations.of(context)!.keyName,
                                    "KEY",
                                    mailbox.instructions.offset,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        spacing: 16,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              Icon(Icons.nfc, size: 20),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Último escaneo",
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                  ..._buildLastAccess(
                                    mailbox.id,
                                    AppLocalizations.of(context)!.packageCode,
                                    "PACKAGE",
                                    mailbox.instructions.offset,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        spacing: 16,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              Icon(Icons.mail, size: 20),
                              Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Última notificacion recibida",
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
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
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 300,
                  child: NotificationsChart(dates: dates, counts: counts),
                ),
              ),
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
        stream: _mailboxService.getLastNotificationByType(mailboxId, type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text(
              'Sin información reciente.',
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
