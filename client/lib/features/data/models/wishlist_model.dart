import '../../domain/entity/wishlist_entity.dart';

class WishlistModel extends WishlistEntity {
  const WishlistModel({
    required super.productId,
    required super.name,
    required super.productPrice,
    required super.initialPrice,
    required super.image,
    required super.overview,
  });
  
  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      productId: json['wishlistId'] ?? '',
      name: json['wishlistName'] ?? '',
      image: json['wishlistImage'] ?? '',
      productPrice: (json['wishlistPrice'] as num).toDouble(),
      initialPrice: (json['wishlistPrice'] as num).toDouble(),
      overview: json['wishlistOverview'] ?? '',
    );
  }
}
