import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/motor/domain/entities/motor_entity.dart';
import 'package:aqua_sol/features/motor/domain/repositories/motor_repository.dart';
import 'package:dartz/dartz.dart';

class GetMotorStatus {
  final MotorRepository repository;

  GetMotorStatus(this.repository);

  Future<Either<Failure, MotorEntity>> call() async {
    return await repository.getMotorStatus();
  }
}