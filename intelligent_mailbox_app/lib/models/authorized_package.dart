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

  factory AuthorizedPackage.fromMap(Map<dynamic, dynamic> data) {
    return AuthorizedPackage(
      permanent: data['permanent'] ?? false,
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      value: data['value'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'permanent': permanent,
      'name': name,
      'id': id,
      'value': value,
    };
  }
}