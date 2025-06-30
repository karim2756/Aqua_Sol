import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'motor_state.dart';

class MotorCubit extends Cubit<MotorState> {
  MotorCubit() : super(MotorInitial());
}
