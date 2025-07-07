part of 'weed_detection_cubit.dart';

abstract class WeedDetectionState {
  const WeedDetectionState();
}

class WeedDetectionInitial extends WeedDetectionState {}

class WeedDetectionLoading extends WeedDetectionState {}

class WeedDetectionLoaded extends WeedDetectionState {
  final WeedDetectionEntity detection;
  const WeedDetectionLoaded(this.detection);
}

class WeedDetectionError extends WeedDetectionState {
  final String message;
  const WeedDetectionError(this.message);
}