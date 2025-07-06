class WaterPumpEntity {
  final bool isOn;
  const WaterPumpEntity({required this.isOn});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WaterPumpEntity && isOn == other.isOn;

  @override
  int get hashCode => isOn.hashCode;
}