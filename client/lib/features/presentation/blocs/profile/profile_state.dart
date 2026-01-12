part of 'profile_bloc.dart';

@immutable
sealed class ProfileUpdateState {
  const ProfileUpdateState();
}

final class ProfileInitial extends ProfileUpdateState {}

final class ProfileUpdateLoading extends ProfileUpdateState {}

final class ProfileUpdateFailure extends ProfileUpdateState {
  final String message;

  const ProfileUpdateFailure(
    this.message,
  );
}

final class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;

  const ProfileUpdateSuccess(
    this.message,
  );
}

final class ProfileUpdateAddressSuccess extends ProfileUpdateState {
  final String message;

  const ProfileUpdateAddressSuccess(
    this.message,
  );
}

final class ProfileUpdateAddressFailure extends ProfileUpdateState {
  final String message;

  const ProfileUpdateAddressFailure(
    this.message,
  );
}

