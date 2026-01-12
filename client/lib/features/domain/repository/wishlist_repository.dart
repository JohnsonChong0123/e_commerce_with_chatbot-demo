import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../entity/wishlist_entity.dart';

abstract class WishlistRepository {
  Future<Either<Failure, Unit>> addToWishlist({
    required String productId,
    required String name,
    required double price,
    required String image,
    required String overview,
  });
  Future<Either<Failure, List<WishlistEntity>>> getWishlist();
  Future<Either<Failure, Unit>> removeFromWishlist(String productId);
  Future<Either<Failure, Unit>> clearWishlist();
}
