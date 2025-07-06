import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/motor/domain/repositories/motor_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleMotor {
  final MotorRepository repository;

  ToggleMotor(this.repository);

  Future<Either<Failure, void>> call(bool turnOn) async {
    return await repository.toggleMotor(turnOn);
  }
}