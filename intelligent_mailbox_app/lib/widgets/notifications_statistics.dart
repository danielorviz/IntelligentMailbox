import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
import 'package:intelligent_mailbox_app/services/notification_service.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';
import 'package:intelligent_mailbox_app/widgets/notifications_chart.dart';
import 'package:provider/provider.dart';

class NotificationsStatistics extends StatefulWidget {
  const NotificationsStatistics({super.key});

  @override
  State<NotificationsStatistics> createState() =>
      _NotificationsStatisticsState();
}

class _NotificationsStatisticsState extends State<NotificationsStatistics> {
  final NotificationService _notificationsService = NotificationService();

  List<int> years = [2022, 2023, 2024, 2025];
  int? selectedYear;
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;

    _initializeYears();
  }

  Future<void> _initializeYears() async {
    final mailboxProvider = Provider.of<MailboxProvider>(
      context,
      listen: false,
    );
    final firstNotificationTime = await _notificationsService
        .getFirstNotificationTime(mailboxProvider.selectedMailbox?.id);

    final firstNotificationYear =
        DateTime.fromMillisecondsSinceEpoch(firstNotificationTime ).year;
    final currentYear = DateTime.now().year;

    setState(() {
      years = List.generate(currentYear - firstNotificationYear + 1, (index) {
        return firstNotificationYear + index;
      });
      selectedYear = currentYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 400,
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 25,
                  ),
                  Text(
                    AppLocalizations.of(context)!.notificationsStatistics,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              Row(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<int>(
                    menuMaxHeight: 300,
                    value: selectedYear,
                    hint: Text(AppLocalizations.of(context)!.selectYear),
                    items:
                        years
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text('$year'),
                              ),
                            )
                            .toList(),
                    onChanged: (year) {
                      setState(() {
                        selectedYear = year;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    menuMaxHeight: 300,
                    value: selectedMonth,
                    hint: Text(AppLocalizations.of(context)!.selectMonth),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(DateTimeUtils.getMonths(context)[index]),
                      );
                    }),
                    onChanged: (month) {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                  ),
                ],
              ),

              Consumer<MailboxProvider>(
                builder: (context, mailboxProvider, child) {
                  final mailbox = mailboxProvider.selectedMailbox;
                  if (mailbox == null) {
                    return _noInfoWidget();
                  }
                  return StreamBuilder<List<int>>(
                    stream: _notificationsService.getWeeklyCountsByMonth(
                      mailboxId: mailbox.id,
                      year: selectedYear ?? DateTime.now().year,
                      month: selectedMonth ?? DateTime.now().month,
                      offset: mailbox.instructions.offset,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _noInfoWidget();
                      }
                      final counts = snapshot.data!;
                      return SizedBox(
                        height: 300,
                        child:  NotificationsChart(counts: counts),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noInfoWidget() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noRecentInfo,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
