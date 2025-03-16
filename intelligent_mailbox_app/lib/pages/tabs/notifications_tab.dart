import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  NotificationsTabState createState() => NotificationsTabState();
}

class NotificationsTabState extends State<NotificationsTab> {
  final MailboxService _mailboxService = MailboxService();

  @override
  Widget build(BuildContext context) {
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    if (mailbox == null) {
      return const Center(child: Text('No mailbox selected'));
    }
    return StreamBuilder<List<MailboxNotification>>(
      stream: _mailboxService.getNotifications(mailbox.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('snapshot error: ${snapshot.error}');
          return const Center(child: Text('Error loading notifications'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No notifications found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        } else {
          final notifications = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total notifications: ${notifications.length}'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification.title),
                      subtitle: Text(notification.message),
                      trailing: Text(notification.time.toString()),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
