import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/review_entity.dart';
import '../../domain/repository/review_repository.dart';
import '../sources/remote/review_remote_data.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteData reviewRemoteData;
  const ReviewRepositoryImpl(this.reviewRemoteData);
  @override
  Future<Either<Failure, Unit>> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      await reviewRemoteData.addReview(
          productId: productId, rating: rating, comment: comment);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

@override
Stream<Either<Failure, List<ReviewEntity>>> getReviews(String productId) {
  return reviewRemoteData.getReviews(productId).map<Either<Failure, List<ReviewEntity>>>(
    (reviewModels) {
      try {
        final reviews = reviewModels.map((model) => model.toEntity()).toList();
        return right(reviews);
      } catch (e) {
        return left(const Failure("Failed to fetch reviews"));
      }
    },
  ).handleError((error, stackTrace) {
    return left(Failure(error.toString()));
  });
}

}
