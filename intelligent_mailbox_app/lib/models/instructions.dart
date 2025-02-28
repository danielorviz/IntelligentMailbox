class Instructions {
  final bool beep;
  final int offset;
  final bool open;

  Instructions({
    required this.beep,
    required this.offset,
    required this.open,
  });

  factory Instructions.fromMap(Map<String, dynamic> data) {
    print(data);
    return Instructions(
      beep: data['beep'] ?? false,
      offset: data['offset'] ?? 0,
      open: data['open'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'beep': beep,
      'offset': offset,
      'open': open,
    };
  }
}