import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/water_pump/domain/repositories/water_pump_repository.dart';
import 'package:dartz/dartz.dart';

class TogglePump {
  final WaterPumpRepository repository;

  TogglePump(this.repository);

  Future<Either<Failure, void>> call(bool turnOn) async {
    return await repository.togglePump(turnOn);
  }
}