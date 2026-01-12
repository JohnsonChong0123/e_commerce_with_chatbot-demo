import '../../../core/entities/product_entity.dart';

class WishlistEntity extends ProductEntity {
  const WishlistEntity({
    required super.productId,
    required super.name,
    required super.image,
    required super.overview,
    required super.productPrice,
    required super.initialPrice,
  });

  @override
  List<Object?> get props => [productId, name, overview, productPrice, initialPrice, image];
}
