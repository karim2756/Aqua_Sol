import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/motor/domain/entities/motor_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MotorRepository {
  Future<Either<Failure, MotorEntity>> getMotorStatus();
  Future<Either<Failure, void>> toggleMotor(bool turnOn);
  Stream<MotorEntity> watchMotorStatus();
}