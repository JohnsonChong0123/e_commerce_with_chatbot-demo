import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/wishlist_repository.dart';

class ClearWishlist implements UseCase<Unit, NoParams> {
  final WishlistRepository wishlistRepository;

  ClearWishlist(this.wishlistRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await wishlistRepository.clearWishlist();
  }
}