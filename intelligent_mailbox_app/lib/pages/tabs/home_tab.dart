import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/widgets/notifications_chart.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Mailbox Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (lastAuthorizedKey != null) ...[
              const Text(
                'Última clave autorizada usada:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Nombre: ${lastAuthorizedKey.name}'),
              Text(
                'Fecha de inicio: ${DateTime.fromMillisecondsSinceEpoch(lastAuthorizedKey.initDate * 1000)}',
              ),
              Text(
                'Fecha de finalización: ${DateTime.fromMillisecondsSinceEpoch(lastAuthorizedKey.finishDate * 1000)}',
              ),
              const SizedBox(height: 20),
            ],
            if (lastPackage != null) ...[
              const Text(
                'Último paquete recibido:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Nombre: ${lastPackage.name}'),
              Text('Valor: ${lastPackage.value}'),
              const SizedBox(height: 20),
            ],
            const Text(
              'Notificaciones recibidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300,
              child: NotificationsChart(counts: counts, dates: dates),
            ),
          ],
        ),
    );
  }
}
