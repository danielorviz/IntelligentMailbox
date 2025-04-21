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

class NotificationsTabState extends State<NotificationsTab>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationsService = NotificationService();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Icon _getIconForType(int type) {
    if (type == MailboxNotification.typeKey) {
      return const Icon(Icons.dialpad, size: 25);
    }
    if (type == MailboxNotification.typePackage) {
      return const Icon(Icons.nfc, size: 25);
    }
    if (type == MailboxNotification.typeLetter) {
      return const Icon(Icons.mail, size: 25);
    }
    if (type == MailboxNotification.typeMailbox) {
      return const Icon(Icons.markunread_mailbox);
    }

    return const Icon(Icons.notifications);
  }

  void _updateAnimationState(bool hasUnreadNotifications) {
    if (hasUnreadNotifications) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();
    final mailboxProvider = Provider.of<MailboxProvider>(context);
    final mailbox = mailboxProvider.selectedMailbox;

    if (mailbox == null) {
      return const Center(child: Text('No mailbox selected'));
    }
    _updateAnimationState(mailboxProvider.unreadNotifications > 0);
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
                      child: Stack(
                        children: [
                          ListTile(
                            title: Row(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(_getIconForType(notification.type).icon),
                                Text(
                                  notification.title,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  if (notification.typeInfo != "") ...{
                                    Text(
                                      notification.typeInfo,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.calendar_month, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateTimeUtils.formatDate(
                                        notification.getTimeWithOffset(),
                                      ),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.access_time, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateTimeUtils.formatTime(
                                        notification.getTimeWithOffset(),
                                      ),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!notification.isRead) ...{
                            Positioned(
                              top: 8,
                              right: 8,
                              child: FadeTransition(
                                opacity: _opacityAnimation,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          },
                        ],
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
