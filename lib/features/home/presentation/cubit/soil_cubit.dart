import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failures.dart';
import '../../../../resources/app_strings.dart';
import '../../domain/entities/soil_entity.dart';
import '../../domain/usecases/get_soil_status_usecase.dart';

part 'soil_state.dart';

class SoilCubit extends Cubit<SoilState> {
  final GetSoilStatus getSoilStatus;
  StreamSubscription? _soilSubscription;

  SoilCubit(this.getSoilStatus) : super(SoilInitial()) {
    _setupSoilListener();
  }

  void _setupSoilListener() {
    _soilSubscription = getSoilStatus().listen(
          (either) {
        either.fold(
              (failure) => emit(SoilError(_mapFailureToMessage(failure))),
              (soil) => emit(SoilLoaded(soil)),
        );
      },
      onError: (error) => emit(SoilError(AppStrings.generalError)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return AppStrings.locNetworkError;
    if (failure is ServerFailure) {
      return failure.message;
    }
    return AppStrings.generalError;
  }

  @override
  Future<void> close() {
    _soilSubscription?.cancel();
    return super.close();
  }
  void reset() {
    _soilSubscription = getSoilStatus().listen(
          (either) {
        either.fold(
              (failure) => emit(SoilError(_mapFailureToMessage(failure))),
              (soil) => emit(SoilLoaded(soil)),
        );
      },
      onError: (error) => emit(SoilError(AppStrings.generalError)),
    );  }
}