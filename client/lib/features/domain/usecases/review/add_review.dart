import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/review_repository.dart';

class AddReview implements UseCase<void, AddReviewParams> {
  final ReviewRepository reviewRepository;

  AddReview(this.reviewRepository);

  @override
  Future<Either<Failure, void>> call(AddReviewParams params) async {
    return await reviewRepository.addReview(
      rating: params.rating,
      comment: params.comment,
      productId: params.productId,
    );
  }
}

class AddReviewParams extends Equatable {
  final double rating;
  final String comment;
  final String productId;

  const AddReviewParams({
    required this.rating,
    required this.comment,
    required this.productId,
  });

  @override
  List<Object?> get props => [rating, comment, productId];
}
