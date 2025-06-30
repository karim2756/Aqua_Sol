part of 'motor_cubit.dart';

abstract class MotorState extends Equatable {
  const MotorState();

  @override
  List<Object> get props => [];
}

class MotorInitial extends MotorState {}
