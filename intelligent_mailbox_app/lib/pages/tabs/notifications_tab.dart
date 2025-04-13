import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:provider/provider.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  NotificationsTabState createState() => NotificationsTabState();
}

class NotificationsTabState extends State<NotificationsTab> {
  final NotificationService _notificationsService = NotificationService();

  Icon _getIconForType(String type) {
    switch (type) {
      case MailboxNotification.typeKey:
        return const Icon(Icons.dialpad, size: 25);
      case MailboxNotification.typePackage:
        return const Icon(Icons.nfc, size: 25);
      case MailboxNotification.typeLetter:
        return const Icon(Icons.mail, size: 25);
      case MailboxNotification.typeMailbox:
        return const Icon(Icons.markunread_mailbox);
      default:
        return const Icon(Icons.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    if (mailbox == null) {
      return const Center(child: Text('No mailbox selected'));
    }
    return StreamBuilder<List<MailboxNotification>>(
      stream: _notificationsService.getNotifications(mailbox.id),
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
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      child: ListTile(
                        title: Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(_getIconForType(notification.type).icon),
                            Text(
                              notification.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(left: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (notification.typeInfo != "") ...{
                              Text(
                                notification.typeInfo,
                                style:
                                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            },
                            ],
                          ),
                        ),
                        trailing: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                Icon(Icons.calendar_month, size: 18),
                                Text(
                                  DateTimeUtils.formatDate(
                                    notification.getTimeWithOffset(
                                      mailbox.instructions.offset,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                Icon(Icons.access_time, size: 18),
                                Text(
                                  DateTimeUtils.formatTime(
                                    notification.getTimeWithOffset(
                                      mailbox.instructions.offset,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
