class Instructions {
  final bool beep;
  final bool open;

  Instructions({
    required this.beep,
    required this.open,
  });

  factory Instructions.fromMap(Map<dynamic, dynamic> data) {
    return Instructions(
      beep: data['beep'] ?? false,
      open: data['open'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'beep': beep,
      'open': open,
    };
  }
}