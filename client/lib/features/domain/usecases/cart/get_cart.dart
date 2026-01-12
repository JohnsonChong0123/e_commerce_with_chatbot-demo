import '../../entity/cart_entity.dart';
import '../../repository/cart_repository.dart';

class GetCart {
  final CartRepository cartRepository;

  GetCart(this.cartRepository);

  Future<List<CartEntity>> call() async {
    return await cartRepository.getCartItem();
  }
}
