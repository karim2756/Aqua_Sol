import 'package:dartz/dartz.dart';

import '../../../../core/failures.dart';
import '../entities/motor_entity.dart';
import '../repositories/motor_repository.dart';

class GetMotorStatus {
  final MotorRepository repository;

  GetMotorStatus(this.repository);

  Future<Either<Failure, MotorEntity>> call() async {
    return await repository.getMotorStatus();
  }
}