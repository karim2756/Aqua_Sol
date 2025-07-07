part of 'soil_cubit.dart';

abstract class SoilState extends Equatable {
  const SoilState();

  @override
  List<Object> get props => [];
}

class SoilInitial extends SoilState {}

class SoilLoading extends SoilState {}

class SoilLoaded extends SoilState {
  final SoilEntity soil;
  const SoilLoaded(this.soil);

  @override
  List<Object> get props => [soil];
}

class SoilError extends SoilState {
  final String message;
  const SoilError(this.message);

  @override
  List<Object> get props => [message];
}