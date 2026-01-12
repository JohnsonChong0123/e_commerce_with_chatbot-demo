import '../../domain/entity/cart_entity.dart';
import '../../domain/repository/cart_repository.dart';
import '../models/cart/cart_model.dart';
import '../sources/local/cart_local_data.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalData cartLocalData;
  const CartRepositoryImpl(this.cartLocalData);

  @override
  Future<List<CartEntity>> getCartItem() {
    final cartItem = cartLocalData.getCartItems();
    return cartItem.then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Future<void> addToCart(CartEntity item) async {
    await cartLocalData.addCartItem(CartModel.fromEntity(item));
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await cartLocalData.removeCartItem(productId);
  }

  @override
  Future<void> clearCart() async {
    await cartLocalData.clearCart();
  }
}
