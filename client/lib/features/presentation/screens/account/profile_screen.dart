import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/app_alert_dialog.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common/utils/pick_image.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../widgets/profile_field.dart';
import '../auth/login_screen.dart';
import '../navbar_screen.dart';

class ProfileScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileCubit>().loadProfile();
    super.initState();
  }

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  String _userId = "";
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<ProfileCubit, ProfileLoadState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Loader();
              } else if (state is ProfileLoadSuccess) {
                _firstNameController.text = state.user.firstName;
                _lastNameController.text = state.user.lastName;
                _emailController.text = state.user.email;
                _phoneController.text = state.user.phone;
                _userId = state.user.userId;
                return Column(
                  children: [
                    ClipOval(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: image == null
                                ? GestureDetector(
                                    onTap: () {
                                      selectImage();
                                    },
                                    child: Image.network(
                                      state.user.image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      selectImage();
                                    },
                                    child:
                                        Image.file(image!, fit: BoxFit.cover),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Colors.black.withValues().withAlpha(50),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColor.placeholderBg,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hi there ${_firstNameController.text.trim()}!",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ProfileField(
                            label: 'First Name',
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),
                          ProfileField(
                            label: 'Last Name',
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),
                          ProfileField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          ProfileField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    BlocConsumer<ProfileBloc, ProfileUpdateState>(
                      listener: (context, updateState) {
                        if (updateState is ProfileUpdateSuccess) {
                          showSnackBar(context, updateState.message);
                          Navigator.push(
                            context,
                            NavBarScreen.route(),
                          );
                        } else if (updateState is ProfileUpdateFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(updateState.message),
                            ),
                          );
                        }
                      },
                      builder: (context, updateState) {
                        if (updateState is ProfileUpdateLoading) {
                          return const Loader();
                        } else {
                          return AppButton(
                            title: 'Update',
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                if (_emailController.text != state.user.email) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AppAlertDialog(
                                      onYesPressed: () {
                                        context.read<ProfileBloc>().add(
                                              ProfileUpdate(
                                                userId: _userId,
                                                firstName:
                                                    _firstNameController.text,
                                                lastName:
                                                    _lastNameController.text,
                                                email: _emailController.text,
                                                phone: _phoneController.text,
                                                image: image,
                                              ),
                                            );
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              const AlertDialog(
                                            content: Row(
                                              children: [
                                                Text(
                                                    'Updating... \nWait for 5 second to logout'),
                                              ],
                                            ),
                                          ),
                                        );
                                        final authBloc =
                                            context.read<AuthBloc>();
                                        Future.delayed(
                                            const Duration(seconds: 5), () {
                                          if (!mounted) return;
                                          authBloc.add(AuthLogout());
                                        });
                                      },
                                      onNoPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      title: 'Email Change',
                                      content:
                                          'Are you sure you want to change your email? You must verify your new email to continue accessing your account',
                                    ),
                                  );
                                } else {
                                  context.read<ProfileBloc>().add(
                                        ProfileUpdate(
                                          userId: _userId,
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          phone: _phoneController.text,
                                          image: image,
                                        ),
                                      );
                                }
                              }
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, authState) {
                        if (authState is AuthSuccess) {
                          showSnackBar(context, authState.message);
                          Navigator.pushReplacement(
                            context,
                            LoginScreen.route(),
                          );
                        } else if (authState is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authState.message),
                            ),
                          );
                        }
                      },
                      builder: (context, authState) {
                        if (authState is AuthLoading) {
                          return const Loader();
                        } else {
                          return AppButton(
                            buttonStyle: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red),
                            ),
                            title: 'Delete Account',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AppAlertDialog(
                                  onYesPressed: () {
                                    context.read<AuthBloc>().add(
                                          AuthDeleteUser(),
                                        );
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const AlertDialog(
                                        content: Row(
                                          children: [
                                            Text(
                                                'Deleting... \nWait for 5 second to logout'),
                                          ],
                                        ),
                                      ),
                                    );
                                    Future.delayed(
                                        const Duration(seconds: 5), () {});
                                  },
                                  onNoPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Delete Account',
                                  content: 'Are you sure delete the user?',
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _userId,
                      style: const TextStyle(color: AppColor.secondary),
                    ),
                  ],
                );
              } else if (state is ProfileLoadFailure) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
