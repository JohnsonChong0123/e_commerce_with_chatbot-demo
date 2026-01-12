part of 'review_bloc.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  
  @override
  List<Object> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewSuccess extends ReviewState {
  final String message;
  const ReviewSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

final class ReviewFailure extends ReviewState {
  final String message;
  const ReviewFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

final class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  const ReviewLoaded(this.reviews);
  
  @override
  List<Object> get props => [reviews];
}
