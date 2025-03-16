class AuthorizedPackage {
  final bool permanent;
  final String name;
  final String id;
  final String value;

  AuthorizedPackage({
    required this.permanent,
    required this.name,
    required this.id,
    required this.value,
  });

  factory AuthorizedPackage.fromMap(Map<dynamic, dynamic> data, String documentId) {
    return AuthorizedPackage(
      permanent: data['permanent'] ?? false,
      name: data['name'] ?? '',
      id: documentId,
      value: data['value'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'permanent': permanent,
      'name': name,
      'value': value,
    };
  }
}