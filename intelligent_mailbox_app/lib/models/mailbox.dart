import 'package:intelligent_mailbox_app/models/authorized_key.dart';
import 'package:intelligent_mailbox_app/models/authorized_package.dart';
import 'package:intelligent_mailbox_app/models/instructions.dart';

class Mailbox {
  final String id;
  final String name;
  Instructions instructions;
  List<AuthorizedKey> authorizedKeys = [];
  List<AuthorizedPackage> authorizedPackages = [];

  Mailbox({required this.id, required this.name,required this.instructions, this.authorizedKeys = const [], this.authorizedPackages = const []});

  factory Mailbox.fromMap(Map<String, dynamic> data, String documentId) {
    final authorizedKeysData = (data['authorizedkeys'] as Map<dynamic, dynamic>?) ?? {};
  final keys = authorizedKeysData.entries.map((entry) {
    return AuthorizedKey.fromMap((entry.value as Map<dynamic, dynamic>).map(
      (key, value) => MapEntry(key.toString(), value),
    ));
  }).toList();

  // Manejar authorizedPackages de forma segura
  final authorizedPackagesData = (data['authorizedPackages'] as Map<dynamic, dynamic>?) ?? {};
  final packages = authorizedPackagesData.entries.map((entry) {
    return AuthorizedPackage.fromMap((entry.value as Map<dynamic, dynamic>).map(
      (key, value) => MapEntry(key.toString(), value),
    ));
  }).toList();

    return Mailbox(
      id: documentId,
      name: data['name'] ?? '',
      instructions: Instructions.fromMap(data['instructions']??{}),
      authorizedKeys: keys,
      authorizedPackages: packages,
    );
  }
}