import 'features/motor/data/datasources/motor_remote_data_source.dart';
import 'features/motor/data/repositories/motor_repository_impl.dart';
import 'features/motor/domain/repositories/motor_repository.dart';
import 'features/motor/domain/usecases/get_motor_status_usecase.dart';
import 'features/motor/domain/usecases/toggle_motor_usecase.dart';
import 'features/motor/presentation/cubit/motor_cubit.dart';
import 'features/water_pump/data/datasources/water_pump_remote_data_source.dart';
import 'features/water_pump/data/repositories/water_pump_repository_impl.dart';
import 'features/water_pump/domain/repositories/water_pump_repository.dart';
import 'features/water_pump/domain/usecases/toggle_pump_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/netwrok_info.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/water_pump/domain/usecases/get_pump_status_usecase.dart';
import 'features/water_pump/presentation/cubit/water_pump_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(
      () => WaterPumpCubit(getPumpStatus: sl(), togglePump: sl()));
  sl.registerFactory(() => MotorCubit(getMotorStatus: sl(), toggleMotor: sl()));

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetPumpStatus(sl()));
  sl.registerLazySingleton(() => TogglePump(sl()));
  sl.registerLazySingleton(() => GetMotorStatus(sl()));
  sl.registerLazySingleton(() => ToggleMotor(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<WaterPumpRepository>(
    () => WaterPumpRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<MotorRepository>(() => MotorRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<WaterPumpRemoteDataSource>(
      () => WaterPumpRemoteDataSource());
      
  sl.registerLazySingleton<MotorRemoteDataSource>(
      () => MotorRemoteDataSource());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), sl()));

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
