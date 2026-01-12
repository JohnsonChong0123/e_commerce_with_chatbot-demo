part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

final class AddReviewEvent extends ReviewEvent {
  final double rating;
  final String comment;
  final String productId;

  const AddReviewEvent({
    required this.rating,
    required this.comment,
    required this.productId,
  });

  @override
  List<Object> get props => [
        rating,
        comment,
        productId,
      ];
}

final class GetReviewsEvent extends ReviewEvent {
  final String productId;

  const GetReviewsEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
