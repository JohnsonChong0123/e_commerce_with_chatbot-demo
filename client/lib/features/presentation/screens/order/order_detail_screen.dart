import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/order_entity.dart';
import '../checkout/checkout_screen.dart';
import '../product/product_detail_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  static route(
    // String orderId,
    // DateTime orderDate,
    // List<OrderItemEntity> orderItem,
    // double subtotal,
    // double shippingFee,
    // double totalAmount,
    OrderEntity order
    
  ) => MaterialPageRoute(
    builder: (context) => OrderDetailScreen(
      order: order
      // orderId: orderId,
      // orderDate: orderDate,
      // orderItem: orderItem,
      // subtotal: subtotal,
      // shippingFee: shippingFee,
      // totalAmount: totalAmount,
      
    ),
  );
  final OrderEntity order;

  // final String orderId;
  // final DateTime orderDate;
  // final List<OrderItemEntity> orderItem;
  // final double subtotal;
  // final double shippingFee;
  // final double totalAmount;
  const OrderDetailScreen({
    super.key,
    required this.order
    // required this.orderId,
    // required this.orderDate,
    // required this.orderItem,
    // required this.subtotal,
    // required this.shippingFee,
    // required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(order.orderId, style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Column(
        children: [
          Text(
            'Order Datetime: ${DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return GestureDetector(
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
                        child: Image.network(item.image, fit: BoxFit.cover),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   item.selectedVariants
                          //       .toString()
                          //       .replaceAll(RegExp(r'[{}]'), ''),
                          //   style: const TextStyle(
                          //     fontSize: 11,
                          //   ),
                          // ),
                          Text(
                            'Qty: ${item.quantity} - \$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 210,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal"),
                  Text("\$${order.subtotal.toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Shipping Fee"),
                  Text("\$${order.shippingFee.toStringAsFixed(2)}"),
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
                    "\$${order.totalAmount.toStringAsFixed(2)}",
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
                      totalAmount: order.totalAmount,
                      subtotal: order.subtotal,
                      shippingFee: order.shippingFee,
                      orderItems: order.orderItems
                          .map(
                            (item) => OrderItemEntity(
                              productId: item.productId,
                              name: item.name,
                              productPrice: item.productPrice,
                              initialPrice: item.initialPrice,
                              image: item.image,
                              overview: item.overview,
                              // variants: item.variants,
                              quantity: item.quantity,
                              // selectedVariants: item.selectedVariants,
                              cartPrice: item.cartPrice,
                              // currency: item.currency,
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
                title: "Order Again",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
