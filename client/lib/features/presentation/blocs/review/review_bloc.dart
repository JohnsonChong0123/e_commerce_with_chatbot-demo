import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../domain/entity/review_entity.dart';
import '../../../domain/usecases/review/add_review.dart';
import '../../../domain/usecases/review/get_review.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReview _addReview;
  final GetReviews _getReviews;

  ReviewBloc({
    required AddReview addReview,
    required GetReviews getReviews,
  })  : _addReview = addReview,
        _getReviews = getReviews,
        super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
    on<GetReviewsEvent>(_onGetReviews);
  }

  void _onAddReview(AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());

    final res = await _addReview(
      AddReviewParams(
        rating: event.rating,
        comment: event.comment,
        productId: event.productId,
      ),
    );

    res.fold(
      (failure) => emit(ReviewFailure(failure.message)),
      (_) => emit(const ReviewSuccess('Review added successfully')),
    );
  }

  void _onGetReviews(GetReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    await emit.forEach(
      _getReviews(event.productId),
      onData: (Either<Failure, List<ReviewEntity>> result) {
        return result.fold(
          (failure) => ReviewFailure(failure.message),
          (reviews) => ReviewLoaded(reviews),
        );
      },
      onError: (error, stackTrace) => ReviewFailure(error.toString()),
    );
  }
}
