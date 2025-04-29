class TimerRecord {
  final String name;
  final int durationInSeconds;

  TimerRecord({required this.name, required this.durationInSeconds});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerRecord &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          durationInSeconds == other.durationInSeconds;

  @override
  int get hashCode => name.hashCode ^ durationInSeconds.hashCode;
}
