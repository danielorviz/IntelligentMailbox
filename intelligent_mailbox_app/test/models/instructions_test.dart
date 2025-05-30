import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_mailbox_app/models/instructions.dart';

void main() {
  group('Instructions', () {
    test('fromMap creates correct instance with all fields', () {
      final data = {'beep': true, 'open': true};
      final instructions = Instructions.fromMap(data);

      expect(instructions.beep, true);
      expect(instructions.open, true);
    });

    test('fromMap sets defaults when fields are missing', () {
      final data = <String, dynamic>{};
      final instructions = Instructions.fromMap(data);

      expect(instructions.beep, false);
      expect(instructions.open, false);
    });

    test('fromMap handles partial data', () {
      final data = {'beep': true};
      final instructions = Instructions.fromMap(data);

      expect(instructions.beep, true);
      expect(instructions.open, false);

      final data2 = {'open': true};
      final instructions2 = Instructions.fromMap(data2);

      expect(instructions2.beep, false);
      expect(instructions2.open, true);
    });

    test('toMap returns correct map', () {
      final instructions = Instructions(beep: true, open: false);
      final map = instructions.toMap();

      expect(map['beep'], true);
      expect(map['open'], false);
    });

    test('constructor requires both fields', () {
      expect(
        () => Instructions(beep: true, open: false),
        returnsNormally,
      );
    });
  });
}