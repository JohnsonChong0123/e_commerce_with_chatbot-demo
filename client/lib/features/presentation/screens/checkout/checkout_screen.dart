import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/order_entity.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../cubit/navbar/navbar_cubit.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../notifiers/payment_select_notifier.dart';
import '../account/location_screen.dart';
import '../navbar_screen.dart';

class CheckoutScreen extends StatelessWidget {
  static route({
    required double subtotal,
    required double shippingFee,
    required double totalAmount,
    required List<OrderItemEntity> orderItems,
  }) =>
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => PaymentSelectionProvider(),
          child: CheckoutScreen(
            subtotal: subtotal,
            shippingFee: shippingFee,
            totalAmount: totalAmount,
            orderItems: orderItems,
          ),
        ),
      );
  final String? address;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final List<OrderItemEntity> orderItems;

  const CheckoutScreen({
    super.key,
    this.address,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().loadProfile();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileLoadState>(
        builder: (context, profile) {
          if (profile is ProfileLoading) {
            return const Center(child: Loader());
          } else if (profile is ProfileLoadSuccess) {
            final address = profile.user.address;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Delivery Address"),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: SizedBox(
                          height: 80,
                          child: Center(
                            child: Text(
                              (address == null || address.isEmpty)
                                  ? "Change Address"
                                  : address,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, LocationScreen.route());
                        },
                        child: const Text(
                          "Change",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Payment method")],
                  ),
                ),
                const SizedBox(height: 10),
                const _PaymentCard(
                    title: "Cash on Delivery", icon: Icons.money),
                const SizedBox(height: 10),
                const _PaymentCard(
                  title: "Credit/Debit Card",
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 10),
                const _PaymentCard(title: "Wallet", icon: Icons.wallet),
                const SizedBox(height: 20),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("\$${subtotal.toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Shipping Fee"),
                          Text("\$${shippingFee.toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        height: 40,
                        color: AppColor.placeholder.withOpacity(0.25),
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount"),
                          Text(
                            "\$${totalAmount.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BlocListener<ProfileBloc, ProfileUpdateState>(
                    listener: (context, state) {
                      if (state is ProfileUpdateSuccess) {
                        _payment(context, state.message);
                      } else if (state is ProfileUpdateFailure) {
                        showSnackBar(context, state.message);
                      }
                    },
                    child: BlocListener<PaymentBloc, PaymentState>(
                      listener: (context, state) {
                        if (state is PaymentSuccess) {
                          _payment(context, state.message);
                        } else if (state is PaymentFailure) {
                          showSnackBar(context, state.message);
                        }
                      },
                      child: AppButton(
                        onPressed: () {
                          final paymentProvider =
                              Provider.of<PaymentSelectionProvider>(
                            context,
                            listen: false,
                          );
                          if (paymentProvider.selectedPaymentMethod ==
                              "Cash on Delivery") {
                            _payment(context, "Payment Successful");
                          } else if (paymentProvider.selectedPaymentMethod ==
                              "Credit/Debit Card") {
                            context.read<PaymentBloc>().add(
                                  PaymentAmount(totalAmount.toStringAsFixed(2)),
                                );
                          } else if (paymentProvider.selectedPaymentMethod ==
                              "Wallet") {
                            final wallet = profile.user.wallet ?? 0.0;
                            if (wallet < totalAmount) {
                              showSnackBar(context, "Insufficient balance");
                            } else {
                              context.read<ProfileBloc>().add(
                                    ProfileUpdateWallet(
                                      amount:
                                          profile.user.wallet! - totalAmount,
                                    ),
                                  );
                            }
                          }
                        },
                        title: "Pay Now",
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (profile is ProfileLoadFailure) {
            return Center(child: Text(profile.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void _payment(BuildContext context, message) {
    context.read<OrderBloc>().add(
          OrderAdd(
            subtotal: subtotal,
            shippingFee: shippingFee,
            totalAmount: totalAmount,
            orderItems: orderItems,
          ),
        );
    showSnackBar(context, message);
    context.read<CartCubit>().clearCart();
    Navigator.pushReplacement(context, _PaymentSuccessScreen.route());
  }
}

class _PaymentCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PaymentCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentSelectionProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 55,
        child: Card(
          child: RadioListTile<String>(
            value: title,
            groupValue: paymentProvider.selectedPaymentMethod,
            onChanged: (value) {
              if (value != null) {
                paymentProvider.selectPaymentMethod(value);
              }
            },
            title: Row(
              children: [
                Icon(icon, color: AppColor.secondary),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 14)),
              ],
            ),
            activeColor: AppColor.green,
            controlAffinity: ListTileControlAffinity.trailing,
            visualDensity: const VisualDensity(vertical: -2),
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessScreen extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const _PaymentSuccessScreen());
  const _PaymentSuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Thank You!",
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text("for your order", style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Your order is now being processed."),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppButton(
              onPressed: () {
                context.read<NavbarCubit>().update(0);
                Navigator.pushReplacement(context, NavBarScreen.route());
              },
              title: "Back To Home",
            ),
          ),
        ],
      ),
    );
  }
}
