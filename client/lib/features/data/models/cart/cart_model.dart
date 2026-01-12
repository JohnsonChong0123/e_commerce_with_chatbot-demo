import 'package:hive/hive.dart';

import '../../../domain/entity/cart_entity.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 0)
class CartModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double cartPrice;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final double productPrice;

  @HiveField(6)
  final String overview;

  @HiveField(7)
  final double initialPrice;

  CartModel({
    required this.productId,
    required this.name,
    required this.productPrice,
    required this.initialPrice,
    required this.cartPrice,
    this.quantity = 1,
    required this.image,
    required this.overview,
  });

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      productId: entity.productId,
      name: entity.name,
      productPrice: entity.productPrice,
      initialPrice: entity.initialPrice,
      cartPrice: entity.cartPrice,
      quantity: entity.quantity,
      image: entity.image,
      overview: entity.overview,
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      productId: productId,
      name: name,
      productPrice: productPrice,
      initialPrice: initialPrice,
      cartPrice: cartPrice,
      image: image,
      quantity: quantity,
      overview: overview,
    );
  }

  CartModel copyWith({
    String? productId,
    String? name,
    double? cartPrice,
    double? productPrice,
    double? initialPrice,
    int? quantity,
    String? image,
    String? overview,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      productPrice: productPrice ?? this.productPrice,
      initialPrice: initialPrice ?? this.initialPrice,
      cartPrice: cartPrice ?? this.cartPrice,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      overview: overview ?? this.overview,
    );
  }
}
