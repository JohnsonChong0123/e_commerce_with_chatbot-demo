part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthSignUp extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const AuthSignUp({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthGoogleLogin extends AuthEvent {}

final class AuthFacebookLogin extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthLogout extends AuthEvent {}

final class AuthForgetPassword extends AuthEvent {
  final String email;

  const AuthForgetPassword({
    required this.email,
  });
}

final class AuthDeleteUser extends AuthEvent {}

