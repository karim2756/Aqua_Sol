class MotorEntity {
  final bool isOn;
  const MotorEntity({required this.isOn});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MotorEntity && isOn == other.isOn;

  @override
  int get hashCode => isOn.hashCode;
}