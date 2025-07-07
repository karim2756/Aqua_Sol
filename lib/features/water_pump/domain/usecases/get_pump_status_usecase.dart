import 'package:dartz/dartz.dart';

import '../../../../core/failures.dart';
import '../entities/water_pump_entity.dart';
import '../repositories/water_pump_repository.dart';

class GetPumpStatus {
  final WaterPumpRepository repository;

  GetPumpStatus(this.repository);

  Future<Either<Failure, WaterPumpEntity>> call() async {
    return await repository.getPumpStatus();
  }
}