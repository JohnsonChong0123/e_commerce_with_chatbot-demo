import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../cubit/navbar/navbar_cubit.dart';
import '../../widgets/password_field.dart';
import '../navbar/account_screen.dart';

class ChangePwScreen extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ChangePwScreen(),
      );
  const ChangePwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Change Password",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(
          30,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add your details to change password",
              ),
              SizedBox(height: 50),
              ChangePasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isObscureOldPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isObscureNewPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isObscureConfirmPassword =
      ValueNotifier<bool>(true);

  final _newPassNotifier = ValueNotifier<PasswordStrength?>(null);
  final _confirmPassNotifier = ValueNotifier<PasswordStrength?>(null);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _isObscureOldPassword.dispose();
    _isObscureNewPassword.dispose();
    _isObscureConfirmPassword.dispose();
    _newPassNotifier.dispose();
    _confirmPassNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PasswordField(
            controller: _oldPasswordController,
            isObscureNotifier: _isObscureOldPassword,
            hintText: "Old Password",
          ),
          const SizedBox(height: 20),
          PasswordField(
            controller: _newPasswordController,
            isObscureNotifier: _isObscureNewPassword,
            strengthNotifier: _newPassNotifier,
            hintText: "New Password",
          ),
          const SizedBox(height: 5),
          PasswordStrengthChecker(
            strength: _newPassNotifier,
          ),
          const SizedBox(height: 20),
          PasswordField(
            controller: _confirmPasswordController,
            isObscureNotifier: _isObscureConfirmPassword,
            strengthNotifier: _confirmPassNotifier,
            hintText: "Confirm Password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your confirm password";
              } else if (value != _newPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          PasswordStrengthChecker(
            strength: _confirmPassNotifier,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              PasswordStrength.instructions,
            ),
          ),
          BlocConsumer<ProfileBloc, ProfileUpdateState>(
            listener: (context, state) {
              if (state is ProfileUpdateFailure) {
                showSnackBar(context, state.message);
              } else if (state is ProfileUpdateSuccess) {
                showSnackBar(context, state.message);
                context.read<NavbarCubit>().update(3);
                Navigator.pushReplacement(
                  context,
                  AccountScreen.route(),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileUpdateLoading) {
                return const Loader();
              } else {
                return AppButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      context.read<ProfileBloc>().add(
                            ProfileChangePassword(
                              oldPassword: _oldPasswordController.text,
                              newPassword: _newPasswordController.text,
                            ),
                          );
                    }
                  },
                  title: 'Change Password',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
