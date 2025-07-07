import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:aqua_sol/core/failures.dart';
import '../entities/weed_detection_entity.dart';

abstract class WeedDetectionRepository {
  Future<Either<Failure, WeedDetectionEntity>> detectWeeds(File imageFile);
  Future<void> loadModel();
}