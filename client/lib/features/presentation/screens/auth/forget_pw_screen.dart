import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/auth_field.dart';
import 'login_screen.dart';

class ForgetPwScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ForgetPwScreen(),
      );
  const ForgetPwScreen({super.key});

  @override
  State<ForgetPwScreen> createState() => _ForgetPwScreenState();
}

class _ForgetPwScreenState extends State<ForgetPwScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              LoginScreen.route(),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          30,
        ),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Please enter your email before reset the password",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Form(
              key: _formkey,
              child: AuthField(
                hintText: "Email",
                controller: _emailController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  showSnackBar(context, state.message);
                  Navigator.pushReplacement(
                    context,
                    LoginScreen.route(),
                  );
                }
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                return AppButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            AuthForgetPassword(
                              email: _emailController.text,
                            ),
                          );
                    }
                  },
                  title: "Send",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
