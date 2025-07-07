import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/failures.dart';
import '../../domain/entities/weed_detection_entity.dart';
import '../../domain/repositories/weed_detection_repository.dart';
import '../datasources/weed_detection_local_data_source.dart';

class WeedDetectionRepositoryImpl implements WeedDetectionRepository {
  final WeedDetectionRemoteDataSource remoteDataSource;

  WeedDetectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeedDetectionEntity>> detectWeeds(File imageFile) async {
    try {
      final result = await remoteDataSource.detectWeeds(imageFile);
      return Right(WeedDetectionEntity(
        label: result['label']!,
        scientificName: result['scientific']!,
        description: result['description']!,
        imageFile: imageFile,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to detect weeds'));
    }
  }

  @override
  Future<void> loadModel() async {
    try {
      await remoteDataSource.loadModel();
    } catch (e) {
      throw ServerFailure(message: 'Failed to load model');
    }
  }
}