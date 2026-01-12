import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/wishlist_entity.dart';
import '../../domain/repository/wishlist_repository.dart';
import '../sources/remote/wishlist_remote_data.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteData wishlistRemoteData;

  WishlistRepositoryImpl(this.wishlistRemoteData);

  @override
  Future<Either<Failure, Unit>> addToWishlist({
    required String productId,
    required String name,
    required double price,
    required String image,
    required String overview,
  }) async {
    try {
      wishlistRemoteData.addToWishlist(
        productId: productId,
        name: name,
        price: price,
        image: image,
        overview: overview,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlist() async {
    try {
      final wishlist = await wishlistRemoteData.getWishlist();
      return right(wishlist);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWishlist(String productId) async {
    try {
      wishlistRemoteData.removeFromWishlist(productId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearWishlist() async {
    try {
      wishlistRemoteData.clearWishlist();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
