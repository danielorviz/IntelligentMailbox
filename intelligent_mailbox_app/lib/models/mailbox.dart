class Mailbox {
  final String id;
  final String name;

  Mailbox({required this.id, required this.name});

  factory Mailbox.fromMap(Map<String, dynamic> data, String documentId) {
      
    return Mailbox(
      id: documentId,
      name: data['name'] ?? '',
    );
  }
}