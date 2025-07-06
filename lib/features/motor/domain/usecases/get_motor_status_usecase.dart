import '../../../../core/failures.dart';
import '../entities/motor_entity.dart';
import '../repositories/motor_repository.dart';
import 'package:dartz/dartz.dart';

class GetMotorStatus {
  final MotorRepository repository;

  GetMotorStatus(this.repository);

  Future<Either<Failure, MotorEntity>> call() async {
    return await repository.getMotorStatus();
  }
}