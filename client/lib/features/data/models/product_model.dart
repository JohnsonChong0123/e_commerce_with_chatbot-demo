import '../../domain/entity/product_view_entity.dart';

class ProductModel extends ProductViewEntity {
  const ProductModel({
    required super.productId,
    required super.name,
    required super.overview,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required super.rating,
    required super.reviewsCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['asin'] ?? '',
      name: json['title'] ?? '',
      overview: json['description'] ?? '',
      productPrice: json['final_prices'] ?? 0.0,
      initialPrice: json['initial_prices'] ?? 0.0,
      image: json['image_url'] ?? '',
      rating: json['rating'] ?? 0,
      reviewsCount: json['reviews_count'] ?? 0,
    );
  }
}
