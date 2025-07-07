import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:aqua_sol/core/failures.dart';
import '../entities/weed_detection_entity.dart';
import '../repositories/weed_detection_repository.dart';

class DetectWeeds {
  final WeedDetectionRepository repository;

  DetectWeeds(this.repository);

  Future<Either<Failure, WeedDetectionEntity>> call(File imageFile) async {
    return await repository.detectWeeds(imageFile);
  }
}

class LoadModel {
  final WeedDetectionRepository repository;

  LoadModel(this.repository);

  Future<void> call() async {
    return await repository.loadModel();
  }
}