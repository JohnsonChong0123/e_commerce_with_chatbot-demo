class CartSummaryEntity {
  final double subtotal;
  final double shippingFee;
  final double total;

  const CartSummaryEntity({
    required this.subtotal,
    required this.shippingFee,
    required this.total,
  });

  factory CartSummaryEntity.zero() => const CartSummaryEntity(
        subtotal: 0,
        shippingFee: 0,
        total: 0,
      );
}
