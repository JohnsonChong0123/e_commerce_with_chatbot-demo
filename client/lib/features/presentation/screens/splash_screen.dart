import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../blocs/auth/auth_bloc.dart';
import 'auth/login_screen.dart';
import 'navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<bool> _showLogo = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    Future.delayed(const Duration(seconds: 3), () {
      _showLogo.value = false;
    });
  }

  @override
  void dispose() {
    _showLogo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showLogo,
      builder: (context, showLogo, child) {
        if (showLogo) {
          return const LogoShowing();
        }
        return Scaffold(
          body: BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              if (isLoggedIn == true) {
                return NavBarScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}

class LogoShowing extends StatelessWidget {
  const LogoShowing({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        child: Center(
          child: Icon(
            Icons.image,
            size: 250,
          ),
        ),
      ),
    );
  }
}
