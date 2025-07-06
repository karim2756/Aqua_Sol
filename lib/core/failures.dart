import 'package:aqua_sol/resources/app_strings.dart';
import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  final String message;
  const Failure({this.message = AppStrings.generalError});
}

// ----------------- General Failures -------------------

class ServerFailure extends Failure {
  const ServerFailure({super.message = AppStrings.locServerErrorMessage});
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = AppStrings.locNetworkErrorMessage});
  @override
  List<Object?> get props => [message];
}

// class TimeoutFailure extends Failure {
//   const TimeoutFailure({super.message = AppStrings.locTimeoutErrorMessage});
//   @override
//   List<Object?> get props => [message];
// }

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = AppStrings.generalError});
  @override
  List<Object?> get props => [message];
}

class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure(
      {super.message = AppStrings.locUnAuthorizedErrorMessage});
  @override
  List<Object?> get props => [message];
}

class LoginAuthFailure extends Failure {
  const LoginAuthFailure({super.message = AppStrings.locLoginAuthErrorMessage});
  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = AppStrings.generalError});
  @override
  List<Object?> get props => [message];
}

class ConflictFailure extends Failure {
  const ConflictFailure({super.message = AppStrings.generalError});
  @override
  List<Object?> get props => [message];
}
//
// class CacheFailure extends Failure {
//   const CacheFailure({super.message = AppStrings.locCacheErrorMessage});
//   @override
//   List<Object?> get props => [message];
// }

class UnimplementedFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

// ----------------- Location Failures -------------------

class LocationFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

class LocationPermissionDeniedFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

class LocationServiceDisabledFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

class LocationPermissionDeniedForeverFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

// ----------------- Pick Image Failures -------------------

class PickImageFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

class CompressImageFailure extends Failure {
  @override
  List<Object?> get props => [message];
}

class UpdateFailure extends Failure {
  @override
  List<Object?> get props => [message];
}
