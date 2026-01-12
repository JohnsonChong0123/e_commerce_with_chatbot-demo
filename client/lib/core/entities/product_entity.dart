import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String productId;
  final String name;
  final String overview;
  final double productPrice;
  final double initialPrice;
  final String image;

  const ProductEntity({
    required this.productId,
    required this.name,
    required this.overview,
    required this.productPrice,
    required this.initialPrice,
    required this.image,
  });

  bool get hasDiscount => initialPrice > productPrice;
  
  @override
  List<Object?> get props => [productId, name, overview, productPrice, initialPrice, image];
}
