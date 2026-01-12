import 'package:equatable/equatable.dart';

import '../../data/models/order_model.dart';
import 'cart_entity.dart';

class OrderEntity extends Equatable {
  final String orderId;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final DateTime orderDate;
  final List<OrderItemEntity> orderItems;

  const OrderEntity({
    required this.orderId,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.orderDate,
    required this.orderItems,
  });

  @override
  List<Object?> get props => [
    orderId,
    subtotal,
    shippingFee,
    totalAmount,
    orderDate,
    orderItems,
  ];
}

class OrderItemEntity extends CartEntity {
  const OrderItemEntity({
    required super.productId,
    required super.name,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required super.overview,
    required super.quantity,
    required super.cartPrice,
  });

  OrderItemModel toModel() {
    return OrderItemModel(
      productId: productId,
      name: name,
      productPrice: productPrice,
      initialPrice: initialPrice,
      image: image,
      overview: overview,
      quantity: quantity,
      cartPrice: cartPrice,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    productPrice,
    image,
    overview,
    quantity,
    cartPrice,
  ];
}
