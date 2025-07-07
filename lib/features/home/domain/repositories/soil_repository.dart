import '../../../../core/failures.dart';
import '../entities/soil_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SoilRepository {
  Stream<Either<Failure, SoilEntity>> watchSoilStatus();
}