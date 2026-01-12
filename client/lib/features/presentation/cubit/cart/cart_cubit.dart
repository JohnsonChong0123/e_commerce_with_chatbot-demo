import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../domain/usecases/cart/add_to_cart.dart';
import '../../../domain/usecases/cart/calculate_cart_summary.dart';
import '../../../domain/usecases/cart/clear_cart.dart';
import '../../../domain/usecases/cart/get_cart.dart';
import '../../../domain/usecases/cart/remove_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final ClearCart clearCart;
  final CalculateCartSummary calculateSummary;

  CartCubit(
    this.getCart,
    this.addToCart,
    this.removeFromCart,
    this.clearCart,
    this.calculateSummary,
  ) : super(CartState.initial());

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true));

    final items = await getCart();
    final summary = calculateSummary(items);

    emit(
      state.copyWith(
        items: items,
        summary: summary,
        isLoading: false,
      ),
    );
  }

  Future<void> addItem({
    required ProductEntity product,
    required int quantity,
    double? priceOverride,
  }) async {
    await addToCart(
      product: product,
      quantity: quantity,
      priceOverride: priceOverride,
    );
    await loadCart();
  }

  Future<void> removeItem(String productId) async {
    await removeFromCart(productId);
    await loadCart();
  }

  Future<void> clear() async {
    await clearCart();
    emit(CartState.initial());
  }
}

