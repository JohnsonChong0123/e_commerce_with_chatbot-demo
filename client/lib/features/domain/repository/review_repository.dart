import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../entity/review_entity.dart';

abstract class ReviewRepository {
  Stream<Either<Failure, List<ReviewEntity>>> getReviews(String productId);
  Future<Either<Failure, Unit>> addReview({
    required String productId,
    required double rating,
    required String comment,
  });
}
