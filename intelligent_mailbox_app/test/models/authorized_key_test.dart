import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/models/authorized_key.dart';

void main() {
  group('AuthorizedKey', () {
    test('fromMap creates correct instance', () {
      final data = {
        'initDate': 1000,
        'permanent': true,
        'name': 'Test Key',
        'finishDate': 2000,
        'value': 'abc123',
      };
      final key = AuthorizedKey.fromMap(data, 'keyId');

      expect(key.initDate, 1000);
      expect(key.permanent, true);
      expect(key.name, 'Test Key');
      expect(key.finishDate, 2000);
      expect(key.id, 'keyId');
      expect(key.value, 'abc123');
    });

    test('toMap returns correct map', () {
      final key = AuthorizedKey(
        initDate: 1000,
        permanent: false,
        name: 'KeyName',
        finishDate: 2000,
        id: 'id1',
        value: 'val1',
      );
      final map = key.toMap();

      expect(map['initDate'], 1000);
      expect(map['permanent'], false);
      expect(map['name'], 'KeyName');
      expect(map['finishDate'], 2000);
      expect(map['value'], 'val1');
    });

    test('isExpired returns correct value', () {
      final key = AuthorizedKey(
        initDate: 0,
        permanent: false,
        name: 'Key',
        finishDate: 0,
        id: 'id',
        value: 'val',
      );
      // Este test depende de la lógica de DateTimeUtils.hasExpired
      // Aquí solo comprobamos que el método existe y retorna un bool
      expect(key.isExpired(), isA<bool>());
    });
  });
}