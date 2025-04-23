import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'weed_detection_state.dart';

class WeedDetectionCubit extends Cubit<WeedDetectionState> {
  WeedDetectionCubit() : super(WeedDetectionInitial());
}
