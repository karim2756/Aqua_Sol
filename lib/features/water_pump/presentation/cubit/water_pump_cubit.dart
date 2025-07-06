import 'dart:async';

import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/water_pump/domain/entities/water_pump_entity.dart';
import 'package:aqua_sol/features/water_pump/domain/usecases/get_pump_status_usecase.dart';
import 'package:aqua_sol/features/water_pump/domain/usecases/toggle_pump_usecase.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:bloc/bloc.dart';
part 'water_pump_state.dart';
class WaterPumpCubit extends Cubit<WaterPumpState> {
  final GetPumpStatus getPumpStatus;
  final TogglePump togglePump;
  StreamSubscription? _pumpSubscription;

  WaterPumpCubit({
    required this.getPumpStatus,
    required this.togglePump,
  }) : super(WaterPumpInitial()) {
    _setupRealtimeListener();
    getInitialStatus();
  }

  Future<void> getInitialStatus() async {
    emit(WaterPumpLoading());
    final result = await getPumpStatus();
    result.fold(
          (failure) => emit(WaterPumpError(
          failure is NetworkFailure
              ? AppStrings.locNetworkError
              :  AppStrings.generalError
      )),
          (pump) => emit(WaterPumpLoaded(pump)),
    );
  }

  void _setupRealtimeListener() {
    _pumpSubscription = togglePump.repository.watchPumpStatus().listen(
          (pump) {
        emit(WaterPumpLoaded(pump));
      },
      onError: (error) {
        emit(WaterPumpError(
            error is NetworkFailure
                ? AppStrings.locNetworkError
                :  AppStrings.generalError
        ));
      },
    );
  }

  Future<void> togglePumpStatus(bool turnOn) async {
    emit(WaterPumpLoading());
    final result = await togglePump(turnOn);
    result.fold(
          (failure) => emit(WaterPumpError(
          failure is NetworkFailure
              ? 'No internet connection'
              : 'Failed to toggle pump'
      )),
          (_) {}, // Success handled by stream
    );
  }

  @override
  Future<void> close() {
    _pumpSubscription?.cancel();
    return super.close();
  }
}