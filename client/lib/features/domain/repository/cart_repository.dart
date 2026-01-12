import '../entity/cart_entity.dart';

abstract interface class CartRepository {
  Future<void> addToCart(CartEntity cart);
  Future<List<CartEntity>> getCartItem();
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
}
