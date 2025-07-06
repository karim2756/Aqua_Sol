import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/water_pump/domain/entities/water_pump_entity.dart';
import 'package:aqua_sol/features/water_pump/domain/repositories/water_pump_repository.dart';
import 'package:dartz/dartz.dart';

class GetPumpStatus {
  final WaterPumpRepository repository;

  GetPumpStatus(this.repository);

  Future<Either<Failure, WaterPumpEntity>> call() async {
    return await repository.getPumpStatus();
  }
}