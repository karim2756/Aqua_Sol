import '../../../../core/failures.dart';
import '../entities/soil_entity.dart';
import '../repositories/soil_repository.dart';
import 'package:dartz/dartz.dart';

class GetSoilStatus {
  final SoilRepository repository;

  GetSoilStatus(this.repository);

  Stream<Either<Failure, SoilEntity>> call() {
    return repository.watchSoilStatus();
  }
}