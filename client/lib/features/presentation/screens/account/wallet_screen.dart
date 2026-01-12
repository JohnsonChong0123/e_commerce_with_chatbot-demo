import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_colors.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../cubit/profile/profile_cubit.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      );

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().loadProfile();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileLoadState>(
        builder: (context, state) {
          if (state is ProfileLoadSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    color: AppColor.placeholderBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColor.green,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.lightGreenAccent,
                            Colors.lightGreen,
                            Colors.green,
                            AppColor.green,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Available Balance',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          const SizedBox(height: 20),
                          Text(
                            '\$${state.user.wallet!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          AddMoneySheet(walletAmount: state.user.wallet!),
                    ),
                    title: 'Add Money',
                  ),
                )
              ],
            );
          } else if (state is ProfileLoadFailure) {
            return Text(
              state.message,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return const Center(
            child: Loader(),
          );
        },
      ),
    );
  }
}

class AddMoneySheet extends StatefulWidget {
  final double walletAmount;
  const AddMoneySheet({
    super.key,
    required this.walletAmount,
  });

  @override
  State<AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<AddMoneySheet> {
  final TextEditingController _amountController = TextEditingController();
  double _amount = 0;
  final _formkey = GlobalKey<FormState>();

  @override
  dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      height: 400,
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, paymentState) {
          if (paymentState is PaymentSuccess) {
            Navigator.pop(context);
            showSnackBar(context, paymentState.message);
            context.read<ProfileBloc>().add(
                  ProfileUpdateWallet(amount: widget.walletAmount + _amount),
                );
            context.read<ProfileCubit>().loadProfile();
          } else if (paymentState is PaymentFailure) {
            showSnackBar(context, paymentState.message);
          }
        },
        child: BlocListener<ProfileBloc, ProfileUpdateState>(
          listener: (context, profileState) {
            if (profileState is ProfileUpdateSuccess) {
            } else if (profileState is ProfileUpdateFailure) {
              showSnackBar(context, profileState.message);
            }
          },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Form(
                    key: _formkey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount is required';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            AppButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _amount = double.parse(_amountController.text.trim());
                  context.read<PaymentBloc>().add(
                        PaymentAmount(_amountController.text),
                      );
                }
              },
              title: 'Add Money',
            ),
            const SizedBox(
              height: 20,
            ),
            AmountButton(
                onTap: () {
                  _amount = 100;
                  context.read<PaymentBloc>().add(
                        const PaymentAmount("100"),
                      );
                },
                text: '\$100'),
            const SizedBox(
              height: 10,
            ),
            AmountButton(
                onTap: () {
                  _amount = 500;
                  context.read<PaymentBloc>().add(
                        const PaymentAmount("500"),
                      );
                },
                text: '\$500'),
            const SizedBox(
              height: 10,
            ),
            AmountButton(
                onTap: () {
                  _amount = 1000;
                  context.read<PaymentBloc>().add(
                        const PaymentAmount("1000"),
                      );
                },
                text: '\$1000'),
            const SizedBox(
              height: 10,
            ),
            AmountButton(
              onTap: () {
                _amount = 2000;
                context.read<PaymentBloc>().add(
                      const PaymentAmount("2000"),
                    );
              },
              text: '\$2000',
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class AmountButton extends StatelessWidget {
  const AmountButton({
    super.key,
    required this.text,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.primary,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
