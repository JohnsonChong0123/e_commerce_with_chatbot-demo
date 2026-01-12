import '../../repository/cart_repository.dart';

class ClearCart {
  final CartRepository cartRepository;

  ClearCart(this.cartRepository);

  Future<void> call() async {
    await cartRepository.clearCart();
  }
}
