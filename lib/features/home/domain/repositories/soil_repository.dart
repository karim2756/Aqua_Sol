import 'package:dartz/dartz.dart';

import '../../../../core/failures.dart';
import '../entities/soil_entity.dart';

abstract class SoilRepository {
  Stream<Either<Failure, SoilEntity>> watchSoilStatus();
}