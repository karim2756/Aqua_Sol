import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/failures.dart';
import '../../../../resources/app_strings.dart';
import '../../domain/entities/motor_entity.dart';
import '../../domain/usecases/get_motor_status_usecase.dart';
import '../../domain/usecases/toggle_motor_usecase.dart';

part 'motor_state.dart';

class MotorCubit extends Cubit<MotorState> {
  final GetMotorStatus _getMotorStatus;
  final ToggleMotor _toggleMotor;
  StreamSubscription? _motorSubscription;

  MotorCubit({
    required GetMotorStatus getMotorStatus,
    required ToggleMotor toggleMotor,
  })  : _getMotorStatus = getMotorStatus,
        _toggleMotor = toggleMotor,
        super(MotorInitial()) {
    _setupRealtimeListener();
    getInitialStatus();
  }

  Future<void> getInitialStatus() async {
    emit(MotorLoading());
    final result = await _getMotorStatus();
    result.fold(
          (failure) => emit(MotorError(
          failure is NetworkFailure
              ? AppStrings.locNetworkError
              :  AppStrings.generalError)),
          (motor) => emit(MotorLoaded(motor)),
    );
  }

  void _setupRealtimeListener() {
    _motorSubscription = _toggleMotor.repository.watchMotorStatus().listen(
          (motor) {
        emit(MotorLoaded(motor));
      },
      onError: (error) {
        emit(MotorError(
            error is NetworkFailure
                ? AppStrings.locNetworkError
                :  AppStrings.generalError));
      },
    );
  }

  Future<void> toggleMotor(bool turnOn) async {
    emit(MotorLoading());
    final result = await _toggleMotor(turnOn);
    result.fold(
          (failure) => emit(MotorError(
          failure is NetworkFailure
              ? AppStrings.locNetworkError
              :  AppStrings.generalError)),
          (_) {}, // Success handled by stream
    );
  }

  @override
  Future<void> close() {
    _motorSubscription?.cancel();
    return super.close();
  }
}