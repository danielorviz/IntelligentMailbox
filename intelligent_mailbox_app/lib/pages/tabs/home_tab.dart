import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/pages/configuration/mailbox_settings.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/widgets/notifications_chart.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {

  
    bool isConnected = false;
    String lastKeyUsed = "1234";
    String lastPackageScanned = "Paquete #5678";
    String lastCheckDate = "Nunca";
    bool _notificationsEnabled = false;


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
  Widget build(BuildContext context) {
    if(!mounted) return const SizedBox.shrink();
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    if (mailbox == null) {
      return const Center(child: Text('No mailbox selected'));
    }

    final lastAuthorizedKey =
        mailbox.authorizedKeys.isNotEmpty ? mailbox.authorizedKeys.last : null;
    final lastPackage =
        mailbox.authorizedPackages.isNotEmpty
            ? mailbox.authorizedPackages.last
            : null;

    final dates = [
      DateTime(2022, 9, 19),
      DateTime(2022, 9, 26),
      DateTime(2022, 10, 3),
      DateTime(2022, 10, 10),
    ];
    final counts = [5, 25, 100, 75];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    (context) => const MailboxSettingsScreen(),
                              ),
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        isConnected ? Icons.wifi : Icons.wifi_off,
                        color: isConnected ? Colors.green : Colors.red,
                        size: 40,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Estado del Buzón",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            isConnected ? "Conectado" : "Desconectado",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: isConnected ? Colors.green : Colors.red,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Última comprobación: ",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: lastCheckDate,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Notificaciones: ",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: _notificationsEnabled
                                      ? "Activadas"
                                      : "Desactivadas",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: _notificationsEnabled
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Zona horaria: ",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                TextSpan(
                                  text: DateTimeUtils.getOffsetStringLabel(context, mailbox.instructions.offset),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Última clave usada",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    lastKeyUsed,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Último paquete escaneado",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    lastPackageScanned,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: NotificationsChart(dates: dates, counts: counts),
          ),
        ],
      ),
    );
  }
}
