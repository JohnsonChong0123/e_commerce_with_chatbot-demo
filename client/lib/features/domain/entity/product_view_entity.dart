import '../../../core/entities/product_entity.dart';

class ProductViewEntity extends ProductEntity {
  final double rating;
  final int reviewsCount;

  const ProductViewEntity({
    required super.productId,
    required super.name,
    required super.overview,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  List<Object?> get props => super.props + [rating, reviewsCount];
}
