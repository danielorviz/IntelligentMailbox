class MailboxInitialConfig {
  final String id;
  final String ip;
  final String wifiPass;

  MailboxInitialConfig({
    required this.id,
    required this.ip,
    required this.wifiPass,
  });

  factory MailboxInitialConfig.fromMap(Map<String, dynamic> data, String documentId) {
    return MailboxInitialConfig(
      id: documentId,
      ip: data['ip'] ?? '',
      wifiPass: data['wifi'] ?? '',
    );
  }
}
