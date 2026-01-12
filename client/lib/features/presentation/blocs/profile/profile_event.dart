part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoad extends ProfileEvent {}

final class ProfileUpdate extends ProfileEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final File? image;

  const ProfileUpdate({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.image,
  });
}

final class ProfileDelete extends ProfileEvent {}

final class ProfileUpdateAddress extends ProfileEvent {
  final String address;
  final double latitude;
  final double longitude;

  const ProfileUpdateAddress({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

final class ProfileUpdateWallet extends ProfileEvent {
  final double amount;

  const ProfileUpdateWallet({
    required this.amount,
  });
}

final class ProfileChangePassword extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ProfileChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });
}
