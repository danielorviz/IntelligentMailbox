class AuthorizedPackage {
  final bool isKey;
  final String name;
  final String id;
  final String value;
  bool received = false;

  AuthorizedPackage({
    required this.isKey,
    required this.name,
    required this.id,
    required this.value,
    required this.received,
  });

  factory AuthorizedPackage.fromMap(Map<dynamic, dynamic> data, String documentId) {
    return AuthorizedPackage(
      isKey: data['isKey'] ?? false,
      name: data['name'] ?? '',
      received: data['received'] ?? false,
      id: documentId,
      value: data['value'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isKey': isKey,
      'name': name,
      'received': received,
      'value': value,
    };
  }
}