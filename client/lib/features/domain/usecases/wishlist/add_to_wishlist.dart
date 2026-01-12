import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/wishlist_repository.dart';

class AddToWishlist implements UseCase<Unit, AddToWishlistParams> {
  final WishlistRepository wishlistRepository;
  const AddToWishlist(this.wishlistRepository);

  @override
  Future<Either<Failure, Unit>> call(AddToWishlistParams params) async {
    return await wishlistRepository.addToWishlist(
      productId: params.productId,
      name: params.name,
      price: params.price,
      image: params.image,
      overview: params.overview,
    );
  }
}

class AddToWishlistParams extends Equatable {
  final String productId;
  final String name;
  final double price;
  final String image;
  final String overview;

  const AddToWishlistParams({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.overview,
  });

  @override
  List<Object?> get props => [productId, name, price, image, overview];
}
