import '../../../core/entities/product_entity.dart';

class CartEntity extends ProductEntity {
  final double cartPrice;
  final int quantity;

  const CartEntity({
    required super.productId,
    required super.name,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required super.overview,
    required this.cartPrice,
    this.quantity = 1,
  });

  double get totalPrice => cartPrice * quantity;

  @override
  List<Object?> get props => [
    productId,
    name,
    productPrice,
    initialPrice,
    cartPrice,
    quantity,
    image,
    overview,
  ];
}
