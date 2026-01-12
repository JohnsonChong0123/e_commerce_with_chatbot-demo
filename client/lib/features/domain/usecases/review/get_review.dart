import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../entity/review_entity.dart';
import '../../repository/review_repository.dart';

class GetReviews {
  final ReviewRepository reviewRepository;

  GetReviews(this.reviewRepository);

  Stream<Either<Failure, List<ReviewEntity>>> call(String productId) {
    return reviewRepository.getReviews(productId);
  }
}

