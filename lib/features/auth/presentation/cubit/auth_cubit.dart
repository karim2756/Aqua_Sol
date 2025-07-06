// auth_cubit.dart
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/netwrok_info.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final NetworkInfo networkInfo;

  AuthCubit(
    this.signInUseCase,
    this.signUpUseCase,
    this.signOutUseCase,
    this.networkInfo,
  ) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    if (!(await networkInfo.isConnected)) {
      emit(AuthError(AppStrings.noInternet.tr()));
      return;
    }

    try {
      final user = await signInUseCase(email, password);
      emit(AuthAuthenticated(user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthError(AppStrings.userNotFound.tr()));
      } else if (e.code == 'wrong-password') {
        emit(AuthError(AppStrings.wrongPassword.tr()));
      } else {
        emit(AuthError(e.message ?? AppStrings.unknownError.tr()));
      }
    } catch (e) {
      emit(AuthError(AppStrings.wrongEmailOrPass.tr()));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    if (!(await networkInfo.isConnected)) {
      emit(AuthError(AppStrings.noInternet.tr()));
      return;
    }

    try {
      final user = await signUpUseCase(email, password, name);
      emit(AuthAuthenticated(user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthError(AppStrings.emailInUse.tr()));
      } else if (e.code == 'weak-password') {
        emit(AuthError(AppStrings.weakPassword.tr()));
      } else {
        emit(AuthError(e.message ?? AppStrings.unknownError.tr()));
      }
    } catch (e) {
      emit(AuthError(AppStrings.unknownError.tr()));
    }
  }

  Future<void> signOut() async {
    await signOutUseCase();
    emit(AuthInitial());
  }
}