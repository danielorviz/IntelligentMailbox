import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/models/instructions.dart';
import 'package:intelligent_mailbox_app/utils/constants.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class Mailbox {
  final String id;
  final String name;
  Instructions instructions;
  List<AuthorizedKey> authorizedKeys = [];
  List<AuthorizedPackage> authorizedPackages = [];
  final String wifiStatus;
  final int lastWifiStatusCheck;
  final int doorStatus;

  Mailbox({
    required this.id,
    required this.name,
    required this.instructions,
    this.authorizedKeys = const [],
    this.authorizedPackages = const [],
    this.wifiStatus = Constants.connectionFailed,
    this.lastWifiStatusCheck = 0,
    this.doorStatus = Constants.doorClosed,

  });

  factory Mailbox.fromMap(Map<String, dynamic> data, String documentId) {
    final authorizedKeysData =
        (data['authorizedkeys'] as Map<dynamic, dynamic>?) ?? {};
    final keys =
        authorizedKeysData.entries.map((entry) {
          return AuthorizedKey.fromMap(
            (entry.value as Map<dynamic, dynamic>).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
            entry.key.toString(),
          );
        }).toList();
        keys.sort(
          (a, b) => a.permanent == b.permanent ? 0 : (a.permanent ? -1 : 1),
        );

    final authorizedPackagesData =
        (data['authorizedPackages'] as Map<dynamic, dynamic>?) ?? {};
    final packages =
        authorizedPackagesData.entries.map((entry) {
          return AuthorizedPackage.fromMap(
            (entry.value as Map<dynamic, dynamic>).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
            entry.key.toString(),
          );
        }).toList();
        packages.sort(
          (a, b) => a.isKey == b.isKey ? 0 : (a.isKey ? -1 : 1),
        );

    return Mailbox(
      id: documentId,
      name: data['name'] ?? '',
      instructions: Instructions.fromMap(data['instructions'] ?? {}),
      authorizedKeys: keys,
      authorizedPackages: packages,
      wifiStatus: data['wifiStatus'] ?? Constants.connectionFailed,
      lastWifiStatusCheck: data['lastWifiStatusCheck'] ?? 0,
      doorStatus: data['doorStatus'] ?? Constants.doorClosed,
    );
  }

  bool getWifiStatusBool() {
    return wifiStatus == Constants.connectionSuccess;
  }

  DateTime getLastWifiStatusCheckWithOffset() {
    int lastDate =
        lastWifiStatusCheck == 0
            ? DateTimeUtils.getUnixTimestampWithoutTimezoneOffset(
              DateTime.now(),
            )
            : lastWifiStatusCheck;
    return DateTimeUtils.getDateTimeFromSecondsAndOffset(
      lastDate,
    );
  }

  bool getDoorStatusBool() {
    return doorStatus == Constants.doorOpened;
  }
}
