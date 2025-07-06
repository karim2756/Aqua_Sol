import '../../../../resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/netwrok_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.dataSource, this.networkInfo);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    if (!await networkInfo.isConnected) {
      throw Exception(AppStrings.noInternet.tr());
    }

    try {
      final user = await dataSource.signIn(email, password);
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception(AppStrings.userNotFound.tr());
      } else if (e.code == 'wrong-password') {
        throw Exception(AppStrings.wrongPassword.tr());
      } else {
        throw Exception(e.message ?? AppStrings.unknownError.tr());
      }
    } catch (_) {
      throw Exception(AppStrings.unknownError.tr());
    }
  }

  @override
  Future<UserEntity?> signUp(String email, String password, String name) async {
    if (!await networkInfo.isConnected) {
      throw Exception(AppStrings.noInternet.tr());
    }

    try {
      final user = await dataSource.signUp(email, password);
      if (user != null) {
        await user.updateDisplayName(name); // Update display name
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception(AppStrings.emailInUse.tr());
      } else if (e.code == 'weak-password') {
        throw Exception(AppStrings.weakPassword.tr());
      } else {
        throw Exception(e.message ?? AppStrings.unknownError.tr());
      }
    } catch (_) {
      throw Exception(AppStrings.unknownError.tr());
    }
  }

  @override
  Future<void> signOut() async => await dataSource.signOut();

  @override
  UserEntity? getCurrentUser() {
    final user = dataSource.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
