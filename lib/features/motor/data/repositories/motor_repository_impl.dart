import '../../../../core/failures.dart';
import '../datasources/motor_remote_data_source.dart';
import '../../domain/entities/motor_entity.dart';
import '../../domain/repositories/motor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/netwrok_info.dart';

class MotorRepositoryImpl implements MotorRepository {
  final MotorRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MotorRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MotorEntity>> getMotorStatus() async {
    if (!await _hasInternet()) {
      return Left(NetworkFailure());
    }

    try {
      final isOn = await remoteDataSource.getMotorStatus();
      return Right(MotorEntity(isOn: isOn));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleMotor(bool turnOn) async {
    if (!await _hasInternet()) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.setMotorStatus(turnOn);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<MotorEntity> watchMotorStatus() {
    return remoteDataSource.watchMotorStatus()
        .map((isOn) => MotorEntity(isOn: isOn))
        .handleError((error) {
      if (error is FirebaseException && error.message?.contains('network') == true) {
        throw NetworkFailure();
      }
      throw ServerFailure(message: error.toString());
    });
  }

  Future<bool> _hasInternet() async {
    return await networkInfo.isConnected;
  }
}