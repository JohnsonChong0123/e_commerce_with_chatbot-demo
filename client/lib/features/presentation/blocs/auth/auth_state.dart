part of 'auth_bloc.dart';

enum AuthLoadingType { google, facebook, login, signUp }

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

final class AuthLoginSuccess extends AuthState {
  final UserEntity user;
  final String message;

  const AuthLoginSuccess(this.user, this.message);
}

final class AuthLoadingGoogle extends AuthState {}

final class AuthLoadingFacebook extends AuthState {}

final class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
}
