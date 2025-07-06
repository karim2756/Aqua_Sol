import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/water_pump/domain/entities/water_pump_entity.dart';
import 'package:dartz/dartz.dart';


abstract class WaterPumpRepository {
  Future<Either<Failure, WaterPumpEntity>> getPumpStatus();
  Future<Either<Failure, void>> togglePump(bool turnOn);
  Stream<WaterPumpEntity> watchPumpStatus();
}