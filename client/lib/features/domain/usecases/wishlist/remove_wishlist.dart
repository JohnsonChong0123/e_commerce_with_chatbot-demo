import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/wishlist_repository.dart';

class RemoveWishlist implements UseCase<Unit, RemoveWishlistParams> {
  final WishlistRepository wishlistRepository;

  RemoveWishlist(this.wishlistRepository);

  @override
  Future<Either<Failure, Unit>> call(RemoveWishlistParams params) async {
    return await wishlistRepository.removeFromWishlist(params.productId);
  }
}

class RemoveWishlistParams extends Equatable {
  final String productId;

  const RemoveWishlistParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
