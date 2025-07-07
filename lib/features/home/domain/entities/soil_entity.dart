class SoilEntity {
  final double moistureValue;
  final bool hasInternet;

  const SoilEntity({
    required this.moistureValue,
    required this.hasInternet,
  });

  String get status {
    if (moistureValue <= 30) return 'Bad';
    if (moistureValue <= 60) return 'Stable';
    return 'Good';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SoilEntity &&
              moistureValue == other.moistureValue &&
              hasInternet == other.hasInternet;

  @override
  int get hashCode => moistureValue.hashCode ^ hasInternet.hashCode;
}