import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../../core/common/widgets/app_alert_dialog.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../blocs/order/order_bloc.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const OrderHistoryScreen(),
      );
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(OrderLoad());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Order History',
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
                    context.read<OrderBloc>().add(OrderClear());
                    showSnackBar(context, 'Order cleared');
                    Navigator.of(context).pop();
                  },
                  onNoPressed: () {
                    Navigator.of(context).pop();
                  },
                  title: 'Clear Order',
                  content: 'This will remove all orders. Continue?',
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Loader();
          } else if (state is OrderLoadedSuccess) {
            if (state.order.isEmpty) {
              return const Center(
                child: Text('No order history'),
              );
            } else {
              return SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: state.order.length,
                  itemBuilder: (context, index) {
                    final order = state.order[index];
                    return Slidable(
                      key: Key(order.orderId.toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (context) => AppAlertDialog(
                                  onYesPressed: () {
                                    context.read<OrderBloc>().add(
                                          OrderRemove(
                                            orderId: order.orderId,
                                          ),
                                        );
                                    showSnackBar(
                                      context,
                                      'Order deleted',
                                    );
                                    Navigator.of(context).pop();
                                    context
                                        .read<OrderBloc>()
                                        .add(OrderLoad());
                                  },
                                  onNoPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Delete Order',
                                  content: 'Are you sure delete the order?',
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
                              builder: (context) => OrderDetailScreen(
                                // orderId: order.orderId,
                                // orderDate: order.orderDate,
                                // orderItem: order.orderItems,
                                // subtotal: order.subtotal,
                                // shippingFee: order.shippingFee,
                                // totalAmount: order.totalAmount,
                                order: order,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            order.orderId.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else if (state is OrderFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
