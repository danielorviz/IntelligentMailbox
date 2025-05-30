import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/models/mailbox_notification.dart';

void main() {
  group('MailboxNotification', () {
    test('fromJson creates correct instance with all fields', () {
      final json = {
        'titulo': 'Título',
        'mensaje': 'Mensaje',
        'time': 123456,
        'mailbox': 'mbx1',
        'type': 2,
        'typeInfo': 'info',
        'isRead': true,
      };
      final notif = MailboxNotification.fromJson(json);

      expect(notif.title, 'Título');
      expect(notif.message, 'Mensaje');
      expect(notif.time, 123456);
      expect(notif.mailboxId, 'mbx1');
      expect(notif.type, 2);
      expect(notif.typeInfo, 'info');
      expect(notif.isRead, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'titulo': 'Sin campos opcionales',
        'mensaje': 'Mensaje',
        'mailbox': 'mbx2',
      };
      final notif = MailboxNotification.fromJson(json);

      expect(notif.title, 'Sin campos opcionales');
      expect(notif.message, 'Mensaje');
      expect(notif.time, 0);
      expect(notif.mailboxId, 'mbx2');
      expect(notif.type, -1);
      expect(notif.typeInfo, '');
      expect(notif.isRead, false);
    });

    test('getTypeInfoName returns correct value when no separator', () {
      final notif = MailboxNotification(
        title: 't',
        message: 'm',
        time: 0,
        mailboxId: 'id',
        type: 1,
        typeInfo: 'simpleInfo',
        isRead: false,
      );
      expect(notif.getTypeInfoName(), 'simpleInfo');
    });

    test('getTypeInfoName returns correct value when separator present', () {
      final notif = MailboxNotification(
        title: 't',
        message: 'm',
        time: 0,
        mailboxId: 'id',
        type: 1,
        typeInfo: 'abc.;.nombre',
        isRead: false,
      );
      expect(notif.getTypeInfoName(), 'nombre');
    });

    test('fromJson throws if required fields are missing', () {
      expect(
        () => MailboxNotification.fromJson({
          // Falta 'titulo'
          'mensaje': 'Mensaje',
          'mailbox': 'mbx',
        }),
        throwsA(isA<TypeError>()), // O isA<Error>() según el caso
      );

      expect(
        () => MailboxNotification.fromJson({
          'titulo': 'Título',
          // Falta 'mensaje'
          'mailbox': 'mbx',
        }),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => MailboxNotification.fromJson({
          'titulo': 'Título',
          'mensaje': 'Mensaje',
          // Falta 'mailbox'
        }),
        throwsA(isA<TypeError>()),
      );
    });
    test('getTimeWithOffset returns correct DateTime', () {
      final notif = MailboxNotification(
        title: 't',
        message: 'm',
        time: 1680000000, // 2023-03-28T20:00:00Z
        mailboxId: 'id',
        type: 1,
        typeInfo: '',
        isRead: false,
      );
      final dt = notif.getTimeWithOffset();
      expect(dt, isA<DateTime>());
      expect(dt.millisecondsSinceEpoch ~/ 1000, 1680000000);
    });

    test('required fields must not be null', () {
      expect(
        () => MailboxNotification(
          title: '',
          message: '',
          time: 0,
          mailboxId: '',
          type: 0,
          typeInfo: '',
          isRead: false,
        ),
        returnsNormally,
      );
    });
  });
}
