import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';

void main() {
  group('AuthorizedPackage', () {
    test('fromMap creates correct instance with all fields', () {
      final data = {
        'isKey': true,
        'name': 'Paquete 1',
        'received': true,
        'value': 'abc123',
      };
      final pkg = AuthorizedPackage.fromMap(data, 'pkgId');

      expect(pkg.isKey, true);
      expect(pkg.name, 'Paquete 1');
      expect(pkg.received, true);
      expect(pkg.id, 'pkgId');
      expect(pkg.value, 'abc123');
    });

    test('fromMap handles missing fields with defaults', () {
      final data = <String, dynamic>{};
      final pkg = AuthorizedPackage.fromMap(data, 'id2');

      expect(pkg.isKey, false);
      expect(pkg.name, '');
      expect(pkg.received, false);
      expect(pkg.id, 'id2');
      expect(pkg.value, '');
    });

    test('fromMap handles partial data', () {
      final data = {
        'name': 'Solo nombre',
        'received': true,
      };
      final pkg = AuthorizedPackage.fromMap(data, 'id3');

      expect(pkg.isKey, false);
      expect(pkg.name, 'Solo nombre');
      expect(pkg.received, true);
      expect(pkg.id, 'id3');
      expect(pkg.value, '');
    });

    test('toMap returns correct map', () {
      final pkg = AuthorizedPackage(
        isKey: false,
        name: 'Caja',
        id: 'id1',
        value: 'val1',
        received: false,
      );
      final map = pkg.toMap();

      expect(map['isKey'], false);
      expect(map['name'], 'Caja');
      expect(map['received'], false);
      expect(map['value'], 'val1');
    });

    test('received can be changed after construction', () {
      final pkg = AuthorizedPackage(
        isKey: true,
        name: 'Modificable',
        id: 'id4',
        value: 'v4',
        received: false,
      );
      pkg.received = true;
      expect(pkg.received, true);
    });
  });
}