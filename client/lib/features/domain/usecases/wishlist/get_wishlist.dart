import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/wishlist_entity.dart';
import '../../repository/wishlist_repository.dart';

class GetWishlist implements UseCase<List<WishlistEntity>, NoParams> {
  final WishlistRepository wishlistRepository;

  GetWishlist(this.wishlistRepository);

  @override
  Future<Either<Failure, List<WishlistEntity>>> call(NoParams params) async {
    return await wishlistRepository.getWishlist();
  }
}
