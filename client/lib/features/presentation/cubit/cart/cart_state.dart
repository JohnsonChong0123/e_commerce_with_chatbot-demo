import '../../../domain/entity/cart_entity.dart';
import '../../../domain/entity/cart_summary_entity.dart';

class CartState {
  final List<CartEntity> items;
  final CartSummaryEntity summary;
  final bool isLoading;

  const CartState({
    required this.items,
    required this.summary,
    this.isLoading = false,
  });

  factory CartState.initial() => CartState(
        items: const [],
        summary: CartSummaryEntity.zero(),
        isLoading: false,
      );

  CartState copyWith({
    List<CartEntity>? items,
    CartSummaryEntity? summary,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
