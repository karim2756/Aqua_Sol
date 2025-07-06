import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.uid, required super.email, super.name});

  factory UserModel.fromFirebaseUser(user) => UserModel(
    uid: user.uid,
    email: user.email ?? '',
    name: user.displayName,
  );
}
