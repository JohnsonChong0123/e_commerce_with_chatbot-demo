import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_alert_dialog.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/order_entity.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../cubit/cart/cart_state.dart';
import '../checkout/checkout_screen.dart';
import '../product/product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const CartScreen());
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.items;
        final summary = state.summary;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Cart',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      onYesPressed: () {
                        context.read<CartCubit>().clear();
                        Navigator.of(context).pop();
                        showSnackBar(context, 'Cart cleared');
                      },
                      onNoPressed: () {
                        Navigator.of(context).pop();
                      },
                      title: 'Clear Cart',
                      content: 'Are you sure clear the cart?',
                    ),
                  );
                },
              ),
            ],
          ),
          body: cart.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Slidable(
                        key: Key(item.productId.toString()),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AppAlertDialog(
                                    onYesPressed: () {
                                      context.read<CartCubit>().removeItem(
                                        item.productId,
                                      );
                                      showSnackBar(
                                        context,
                                        '${item.name} removed from cart',
                                      );
                                      Navigator.of(context).pop();
                                      // context.read<CartCubit>().loadCart();
                                    },
                                    onNoPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: 'Delete Item',
                                    content: 'Are you sure delete the item?',
                                  ),
                                );
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: item),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(fontSize: 15),
                            ),
                            subtitle: Text(
                              'Qty: ${item.quantity} - \$${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            // ],
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          bottomNavigationBar: cart.isEmpty
              ? const SizedBox()
              : BottomAppBar(
                  height: 210,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal"),
                            Text("\$${summary.subtotal.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Shipping Fee"),
                            Text("\$${summary.shippingFee.toStringAsFixed(2)}"),
                          ],
                        ),
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
                              "\$${summary.total.toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CheckoutScreen.route(
                                totalAmount: summary.total,
                                subtotal: summary.subtotal,
                                shippingFee: summary.shippingFee,
                                orderItems: cart
                                    .map(
                                      (item) => OrderItemEntity(
                                        productId: item.productId,
                                        name: item.name,
                                        productPrice: item.productPrice,
                                        initialPrice: item.initialPrice,
                                        image: item.image,
                                        overview: item.overview,
                                        quantity: item.quantity,
                                        cartPrice: item.cartPrice,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                          title: "Checkout",
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
