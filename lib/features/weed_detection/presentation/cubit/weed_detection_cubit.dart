import 'dart:io';
import 'package:aqua_sol/features/weed_detection/domain/entities/weed_detection_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/weed_detection/domain/usecases/load_model_usecase.dart';
import 'package:aqua_sol/resources/app_strings.dart';

part 'weed_detection_state.dart';

class WeedDetectionCubit extends Cubit<WeedDetectionState> {
  final DetectWeeds detectWeeds;
  final LoadModel loadModel;

  WeedDetectionCubit({
    required this.detectWeeds,
    required this.loadModel,
  }) : super(WeedDetectionInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(WeedDetectionLoading());
    try {
      await loadModel();
      emit(WeedDetectionInitial());
    } catch (e) {
      emit(WeedDetectionError(AppStrings.generalError));
    }
  }

  Future<void> detectFromImage(File imageFile) async {
    emit(WeedDetectionLoading());
    final result = await detectWeeds(imageFile);
    result.fold(
          (failure) => emit(WeedDetectionError(_mapFailureToMessage(failure))),
          (detection) => emit(WeedDetectionLoaded(detection)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return AppStrings.generalError;
  }
  void reset() {
    emit(WeedDetectionInitial());
  }
}