// water_pump_repository_impl.dart
import 'package:aqua_sol/core/failures.dart';
import 'package:aqua_sol/features/water_pump/data/datasources/water_pump_remote_data_source.dart';
import 'package:aqua_sol/features/water_pump/domain/entities/water_pump_entity.dart';
import 'package:aqua_sol/features/water_pump/domain/repositories/water_pump_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/netwrok_info.dart';


class WaterPumpRepositoryImpl implements WaterPumpRepository {
  final WaterPumpRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WaterPumpRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WaterPumpEntity>> getPumpStatus() async {
    if (!await  _hasInternet()) {
      return Left(NetworkFailure());
    }

    try {
      final isOn = await remoteDataSource.getPumpStatus();
      return Right(WaterPumpEntity(isOn: isOn));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> togglePump(bool turnOn) async {
    if (!await  _hasInternet()) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.setPumpStatus(turnOn);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<WaterPumpEntity> watchPumpStatus() {
    return remoteDataSource.watchPumpStatus()
        .map((isOn) => WaterPumpEntity(isOn: isOn))
        .handleError((error) {
      if (error is FirebaseException && error.message?.contains('network') == true) {
        throw NetworkFailure();
      }
      throw ServerFailure(message: error.toString());
    });
  }
  Future<bool> _hasInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }
}