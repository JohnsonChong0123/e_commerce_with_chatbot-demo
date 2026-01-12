part of 'order_bloc.dart';

sealed class OrderEvent {
  const OrderEvent();
}

final class OrderAdd extends OrderEvent {
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final List<OrderItemEntity> orderItems;

  const OrderAdd({
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.orderItems,
  });
}

final class OrderLoad extends OrderEvent {}

final class OrderRemove extends OrderEvent {
  final String orderId;

  const OrderRemove({
    required this.orderId,
  });
}

final class OrderClear extends OrderEvent {}
