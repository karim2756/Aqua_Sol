part of 'motor_cubit.dart';

abstract class MotorState {
  const MotorState();
}

class MotorInitial extends MotorState {}

class MotorLoading extends MotorState {}

class MotorLoaded extends MotorState {
  final MotorEntity motor;
  const MotorLoaded(this.motor);
}

class MotorError extends MotorState {
  final String message;
  const MotorError(this.message);
}