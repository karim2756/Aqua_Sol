import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures.dart';
import '../../../../core/netwrok_info.dart';
import '../../../../resources/app_strings.dart';
import '../../domain/entities/soil_entity.dart';
import '../../domain/repositories/soil_repository.dart';
import '../datasources/soil_remote_data_source.dart';

class SoilRepositoryImpl implements SoilRepository {
  final SoilRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SoilRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<Either<Failure, SoilEntity>> watchSoilStatus() async* {
    if (!await networkInfo.isConnected) {
      yield Left(NetworkFailure());
      return;
    }

    yield* remoteDataSource.watchMoisture().asyncMap((moisture) async {
      try {
        // Check connection again in case it dropped
        if (!await networkInfo.isConnected) {
          return Left(NetworkFailure());
        }

        return Right(SoilEntity(
          moistureValue: moisture,
          hasInternet: true, // We know we have internet if we got here
        ));
      } on FirebaseException {
        return Left(ServerFailure(message: AppStrings.generalError.tr()));
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }
}