import '../../../../core/entities/product_entity.dart';
import '../../entity/cart_entity.dart';
import '../../repository/cart_repository.dart';

class AddToCart {
  final CartRepository cartRepository;

  AddToCart(this.cartRepository);

  Future<void> call({
    required ProductEntity product,
    required int quantity,
    double? priceOverride,
  }) async {
    final cartItem = CartEntity(
      productId: product.productId,
      name: product.name,
      image: product.image,
      overview: product.overview,
      initialPrice: product.initialPrice,
      productPrice: product.productPrice,
      quantity: quantity,
      cartPrice: priceOverride ?? product.productPrice,
    );

    await cartRepository.addToCart(cartItem);
  }
}

