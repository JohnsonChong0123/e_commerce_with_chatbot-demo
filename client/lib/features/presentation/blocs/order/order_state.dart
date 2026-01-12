part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();

  @override
  List<Object> get props => [];
}

final class OrderLoading extends OrderState {
  const OrderLoading();

  @override
  List<Object> get props => [];
}

final class OrderSuccess extends OrderState {
  final String message;

  const OrderSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderLoadedSuccess extends OrderState {
  final List<OrderEntity> order;

  const OrderLoadedSuccess(this.order);

  @override
  List<Object> get props => [order];
}
