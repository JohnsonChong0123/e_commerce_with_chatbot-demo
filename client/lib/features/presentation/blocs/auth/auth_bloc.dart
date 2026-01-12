import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/user/current_user.dart';
import '../../../domain/usecases/user/delete_user.dart';
import '../../../domain/usecases/user/facebook_login.dart';
import '../../../domain/usecases/user/forget_password.dart';
import '../../../domain/usecases/user/google_login.dart';
import '../../../domain/usecases/user/update_user.dart';
import '../../../domain/usecases/user/user_login.dart';
import '../../../domain/usecases/user/user_signout.dart';
import '../../../domain/usecases/user/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final GoogleLogin _googleLogin;
  final FacebookLogin _facebookLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserSignOut _signOut;
  final ForgetPassword _forgetPassword;
  final DeleteUser _deleteUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required GoogleLogin googleLogin,
    required FacebookLogin facebookLogin,
    required UpdateUser updateUser,
    required UserSignOut signOut,
    required ForgetPassword forgetPassword,
    required DeleteUser deleteUser,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _googleLogin = googleLogin,
        _facebookLogin = facebookLogin,
        _signOut = signOut,
        _forgetPassword = forgetPassword,
        _deleteUser = deleteUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthGoogleLogin>(_onGoogleLogin);
    on<AuthFacebookLogin>(_onFacebookLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthForgetPassword>(_onForgetPassword);
    on<AuthDeleteUser>(_onDeleteUser);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) => emit(
        const AuthSuccess(
            "Successfully signed up! Please enter your email and password to login."),
      ),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit, 'Successfully logged in'),
    );
  }

  void _onGoogleLogin(AuthGoogleLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoadingGoogle());
    final res = await _googleLogin(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit, 'Successfully logged in'),
    );
  }

  void _onFacebookLogin(
      AuthFacebookLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoadingFacebook());
    final res = await _facebookLogin(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit, 'Successfully logged in'),
    );
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit, 'Welcome'),
    );
  }

  void _emitAuthSuccess(
      UserEntity user, Emitter<AuthState> emit, String message) {
    _appUserCubit.updateUser(user);
    emit(AuthLoginSuccess(user, message));
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final res = await _signOut(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) {
        emit(const AuthSuccess('Successfully logged out'));
      },
    );
  }

  void _onForgetPassword(
      AuthForgetPassword event, Emitter<AuthState> emit) async {
    final res = await _forgetPassword(
      ForgetPasswordParams(email: event.email),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) {
        emit(
          const AuthSuccess(
            'Check your email for resetting password',
          ),
        );
      },
    );
  }

  void _onDeleteUser(AuthDeleteUser event, Emitter<AuthState> emit) async {
    final res = await _deleteUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) {
        emit(
          const AuthSuccess(
            'Successfully deleted user',
          ),
        );
      },
    );
  }
}
