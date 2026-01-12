import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UpdateUser implements UseCase<UserEntity, UpdateUserParams> {
  final UserRepository userRepository;

  UpdateUser(this.userRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await userRepository.updateUser(
      userId: params.userId,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      image: params.image,
    );
  }
}

class UpdateUserParams extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final File? image;

  const UpdateUserParams({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.image,
  });
  
  @override
  List<Object?> get props => [userId, firstName, lastName, email, phone, image];
}
