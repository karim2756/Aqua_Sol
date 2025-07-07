import 'package:dartz/dartz.dart';

import '../../../../core/failures.dart';
import '../repositories/motor_repository.dart';

class ToggleMotor {
  final MotorRepository repository;

  ToggleMotor(this.repository);

  Future<Either<Failure, void>> call(bool turnOn) async {
    return await repository.toggleMotor(turnOn);
  }
}