import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/models/mailbox.dart';
import 'package:intelligent_mailbox_app/models/instructions.dart';
import 'package:intelligent_mailbox_app/utils/constants.dart';

void main() {
  group('Mailbox', () {
    test('fromMap creates correct instance with all fields', () {
      final data = {
        'name': 'Buzón 1',
        'instructions': {'open': false},
        'authorizedkeys': {
          'key1': {
            'initDate': 1,
            'permanent': true,
            'name': 'Key1',
            'finishDate': 2,
            'value': 'val1',
          },
        },
        'authorizedPackages': {
          'pkg1': {
            'isKey': true,
            'name': 'Paquete1',
            'received': false,
            'value': 'v1',
          },
        },
        'wifiStatus': Constants.connectionSuccess,
        'lastWifiStatusCheck': 123456,
        'doorStatus': Constants.doorOpened,
        'language': 'es',
      };

      final mailbox = Mailbox.fromMap(data, 'id1');

      expect(mailbox.id, 'id1');
      expect(mailbox.name, 'Buzón 1');
      expect(mailbox.instructions, isA<Instructions>());
      expect(mailbox.instructions.open, false);
      expect(mailbox.authorizedKeys.length, 1);
      expect(mailbox.authorizedKeys.first.name, 'Key1');
      expect(mailbox.authorizedPackages.length, 1);
      expect(mailbox.authorizedPackages.first.name, 'Paquete1');
      expect(mailbox.wifiStatus, Constants.connectionSuccess);
      expect(mailbox.lastWifiStatusCheck, 123456);
      expect(mailbox.doorStatus, Constants.doorOpened);
      expect(mailbox.language, 'es');
    });

    test('fromMap handles missing optional fields', () {
      final data = {
        'name': 'Buzón vacío',
        'instructions': {},
      };

      final mailbox = Mailbox.fromMap(data, 'id2');

      expect(mailbox.id, 'id2');
      expect(mailbox.name, 'Buzón vacío');
      expect(mailbox.instructions, isA<Instructions>());
      expect(mailbox.authorizedKeys, isEmpty);
      expect(mailbox.authorizedPackages, isEmpty);
      expect(mailbox.wifiStatus, Constants.connectionFailed);
      expect(mailbox.lastWifiStatusCheck, 0);
      expect(mailbox.doorStatus, Constants.doorClosed);
      expect(mailbox.language, Constants.getDefaultLocale());
    });

    test('fromMap throws if required fields are missing', () {
      expect(
        () => Mailbox.fromMap({}, 'id3'),
        returnsNormally, // No lanza, pone valores por defecto
      );
      expect(
        () => Mailbox.fromMap({'instructions': {}}, 'id4'),
        returnsNormally,
      );
    });

    test('getWifiStatusBool returns true if wifiStatus is connectionSuccess', () {
      final mailbox = Mailbox(
        id: 'id',
        name: 'n',
        instructions: Instructions.fromMap({}),
        wifiStatus: Constants.connectionSuccess,
      );
      expect(mailbox.getWifiStatusBool(), isTrue);
    });

    test('getWifiStatusBool returns false if wifiStatus is not connectionSuccess', () {
      final mailbox = Mailbox(
        id: 'id',
        name: 'n',
        instructions: Instructions.fromMap({}),
        wifiStatus: Constants.connectionFailed,
      );
      expect(mailbox.getWifiStatusBool(), isFalse);
    });

    test('getDoorStatusBool returns true if doorStatus is doorOpened', () {
      final mailbox = Mailbox(
        id: 'id',
        name: 'n',
        instructions: Instructions.fromMap({}),
        doorStatus: Constants.doorOpened,
      );
      expect(mailbox.getDoorStatusBool(), isTrue);
    });

    test('getDoorStatusBool returns false if doorStatus is not doorOpened', () {
      final mailbox = Mailbox(
        id: 'id',
        name: 'n',
        instructions: Instructions.fromMap({}),
        doorStatus: Constants.doorClosed,
      );
      expect(mailbox.getDoorStatusBool(), isFalse);
    });

    test('getLastWifiStatusCheckWithOffset returns DateTime', () {
      final mailbox = Mailbox(
        id: 'id',
        name: 'n',
        instructions: Instructions.fromMap({}),
        lastWifiStatusCheck: 123456,
      );
      expect(mailbox.getLastWifiStatusCheckWithOffset(), isA<DateTime>());
    });

    test('authorizedKeys and authorizedPackages are sorted', () {
      final data = {
        'name': 'Buzón',
        'instructions': {},
        'authorizedkeys': {
          'key1': {'permanent': false, 'name': 'K1'},
          'key2': {'permanent': true, 'name': 'K2'},
        },
        'authorizedPackages': {
          'pkg1': {'isKey': false, 'name': 'P1'},
          'pkg2': {'isKey': true, 'name': 'P2'},
        },
      };
      final mailbox = Mailbox.fromMap(data, 'id3');
      // permanent == true debe ir antes
      expect(mailbox.authorizedKeys.first.permanent, isTrue);
      // isKey == true debe ir antes
      expect(mailbox.authorizedPackages.first.isKey, isTrue);
    });

    test('Mailbox constructor throws if required fields are null', () {
      expect(
        () => Mailbox(
          id: 'id',
          name: 'n',
          instructions: Instructions.fromMap({}),
          authorizedKeys: [],
          authorizedPackages: [],
        ),
        returnsNormally,
      );
    });
  });
}