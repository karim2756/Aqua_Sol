part of 'water_pump_cubit.dart';

abstract class WaterPumpState {
  const WaterPumpState();
}

class WaterPumpInitial extends WaterPumpState {}

class WaterPumpLoading extends WaterPumpState {}

class WaterPumpLoaded extends WaterPumpState {
  final WaterPumpEntity pump;
  const WaterPumpLoaded(this.pump);
}

class WaterPumpError extends WaterPumpState {
  final String message;
  const WaterPumpError(this.message);
}