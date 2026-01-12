import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../core/entities/user_entity.dart';
import '../../../core/errors/failure.dart';

abstract interface class UserRepository {
  Future<Either<Failure, Unit>> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, UserEntity>> loginWithFacebook();

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> forgetPassword({
    required String email,
  });

  Future<Either<Failure, UserEntity>> currentUser();

  Future<Either<Failure, UserEntity>> getUserProfile();

  Future<Either<Failure, UserEntity>> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required File? image,
  });

  Future<Either<Failure, Unit>> updateUserAddress({
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, Unit>> deleteUser();

  Future<Either<Failure, Unit>> updateUserWallet({
    required double amount,
  });

  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
