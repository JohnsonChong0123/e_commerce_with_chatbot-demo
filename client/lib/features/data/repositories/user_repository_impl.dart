import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../core/entities/user_entity.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/repository/user_repository.dart';
import '../models/user_model.dart';
import '../sources/local/cart_local_data.dart';
import '../sources/remote/user_remote_data.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteData userRemoteData;
  final CartLocalData cartLocalData;
  const UserRepositoryImpl(this.userRemoteData, this.cartLocalData);

  @override
  Future<Either<Failure, Unit>> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await userRemoteData.signUpWithEmailPassword(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await userRemoteData.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    return _getUser(() async => await userRemoteData.loginWithGoogle());
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook() async {
    return _getUser(() async => await userRemoteData.loginWithFacebook());
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await cartLocalData.closeCartBox();
      await userRemoteData.signOut();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgetPassword({required String email}) async {
    try {
      await userRemoteData.forgetPassword(email: email);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      final user = await userRemoteData.getCurrentUser();

      if (user == null) {
        return left(const Failure('User is not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await userRemoteData.getUserProfile();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required File? image,
  }) async {
    try {
      UserModel userModel = UserModel(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        image: '',
      );

      if (image == null) {
        userModel = userModel.copyWith(
          image: await userRemoteData.getStorageImage(userId: userId),
        );
        await userRemoteData.updateUser(userModel: userModel);
        return right(userModel);
      } else {
        final imageUrl = await userRemoteData.uploadUserImage(
          image: image,
          user: userModel,
        );

        userModel = userModel.copyWith(image: imageUrl);

        await userRemoteData.updateUser(userModel: userModel);
        return right(userModel);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await userRemoteData.updateUserAddress(
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    try {
      await cartLocalData.deleteCartBox();
      await userRemoteData.deleteUser();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserEntity>> _getUser(
    Future<UserModel> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserWallet({
    required double amount,
  }) async {
    try {
      await userRemoteData.updateUserWallet(amount: amount);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await userRemoteData.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
