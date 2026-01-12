part of 'profile_cubit.dart';

@immutable
sealed class ProfileLoadState {}

final class ProfileInitial extends ProfileLoadState {}

class ProfileLoading extends ProfileLoadState {}

class ProfileLoadSuccess extends ProfileLoadState {
  final UserEntity user;

  ProfileLoadSuccess(this.user);
}

class ProfileLoadFailure extends ProfileLoadState {
  final String message;

  ProfileLoadFailure(this.message);
}
