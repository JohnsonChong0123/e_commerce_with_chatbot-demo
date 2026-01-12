import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.orderId,
    required super.subtotal,
    required super.shippingFee,
    required super.totalAmount,
    required super.orderDate,
    required super.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      subtotal: (json['orderSubtotal'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['orderShippingFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['orderTotalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: DateTime.parse(json['orderDatetime']),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderSubtotal': subtotal,
      'orderShippingFee': shippingFee,
      'orderTotalAmount': totalAmount,
      'orderDatetime': orderDate.toIso8601String(),
      'orderItems':
          orderItems.map((item) => (item.toModel()).toJson()).toList(),
    };
  }
}

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.name,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required super.overview,
    required super.cartPrice,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      name: json['productName'],
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      initialPrice: (json['initialPrice'] as num?)?.toDouble() ?? 0.0,
      image: json['productImage'],
      overview: json['productOverview'],
      cartPrice: (json['cartPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['cartQuantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': name,
      'productPrice': productPrice,
      'initialPrice': initialPrice,
      'productImage': image,
      'productOverview': overview,
      'cartPrice': cartPrice,
      'cartQuantity': quantity,
    };
  }
}
