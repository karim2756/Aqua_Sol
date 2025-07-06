import '../../../../core/failures.dart';
import '../repositories/water_pump_repository.dart';
import 'package:dartz/dartz.dart';

class TogglePump {
  final WaterPumpRepository repository;

  TogglePump(this.repository);

  Future<Either<Failure, void>> call(bool turnOn) async {
    return await repository.togglePump(turnOn);
  }
}