import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../cubit/navbar/navbar_cubit.dart';
import '../../blocs/wishlist/wishlist_bloc.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../notifiers/product_details_notifier.dart';
import '../navbar_screen.dart';
import 'review_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static route(ProductEntity product) => MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      );
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: AppColor.primary),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                context.read<NavbarCubit>().update(1);
                Navigator.pushReplacement(context, NavBarScreen.route());
              },
              icon: const Icon(Icons.shopping_cart, color: AppColor.primary),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                          WishlistButton(product: product),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          if (product.hasDiscount) ...[
                            Text(
                              "\$${product.initialPrice.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColor.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            "\$${product.productPrice.toStringAsFixed(2)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColor.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'DESCRIPTION',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.overview,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text(
                              "View Review >>>",
                              style: TextStyle(color: AppColor.green),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                ProductReviewScreen.route(product.productId),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () {
            _showCartDialog(context);
          },
          child: const Text(
            'Add to cart',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ProductDetailsNotifier(),
        child: CartDialog(product: product),
      ),
    );
  }
}

class CartDialog extends StatelessWidget {
  final ProductEntity product;

  const CartDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColor.placeholder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(product.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(color: AppColor.primary, fontSize: 15),
              ),
              Consumer<ProductDetailsNotifier>(
                builder: (context, notifier, _) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          notifier.minusQuantity();
                        },
                        icon: const Icon(Icons.remove, color: Colors.green),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${notifier.quantity}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          notifier.addQuantity();
                        },
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            onPressed: () {
              final notifier = context.read<ProductDetailsNotifier>();
              context.read<CartCubit>().addItem(
                    product: product,
                    quantity: notifier.quantity,
                    priceOverride: notifier.price,
                  );
              // context.read<CartCubit>().addItem(cart);
              Navigator.of(context).pop();
              showSnackBar(context, "Added to cart");
            },
            title: 'Add to cart',
          ),
        ],
      ),
    );
  }
}

class WishlistButton extends StatelessWidget {
  final ProductEntity product;

  const WishlistButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        final isFavorite = state is WishlistLoaded &&
            state.wishlist.any((item) => item.productId == product.productId);
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            if (isFavorite) {
              context.read<WishlistBloc>().add(
                    RemoveWishlistEvent(productId: product.productId),
                  );
              showSnackBar(context, "Removed from wishlist");
            } else {
              context.read<WishlistBloc>().add(
                    AddToWishlistEvent(
                      productId: product.productId,
                      name: product.name,
                      price: product.productPrice,
                      image: product.image,
                      overview: product.overview,
                    ),
                  );
              showSnackBar(context, "Added to wishlist");
            }
            context.read<WishlistBloc>().add(GetWishlistEvent());
          },
        );
      },
    );
  }
}
