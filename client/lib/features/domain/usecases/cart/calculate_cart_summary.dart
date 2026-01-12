import '../../entity/cart_entity.dart';
import '../../entity/cart_summary_entity.dart';

class CalculateCartSummary {
  CartSummaryEntity call(List<CartEntity> items) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    final double shippingFee = subtotal == 0 ? 0 : subtotal * 0.01;

    return CartSummaryEntity(
      subtotal: subtotal,
      shippingFee: shippingFee,
      total: subtotal + shippingFee,
    );
  }
}
